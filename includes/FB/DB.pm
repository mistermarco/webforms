#
# Written by Marco Wise <marco.wise@stanford.edu>
# Copyright 2008,2009 Board of Trustees, Leland Stanford Jr. University
#
# See LICENSE for licensing terms.
#
package FB::DB;
use base 'Class::DBI';

use AppConfig qw(:expand :argcount);

my $config = AppConfig->new(
    'db_host' => {
        ARGCOUNT => ARGCOUNT_ONE,
        DEFAULT  => '127.0.0.1',
    },
    'db_port' => {
        ARGCOUNT => ARGCOUNT_ONE,
        DEFAULT  => '3306',
    },
    'db_username'           => {
        ARGCOUNT => ARGCOUNT_ONE,
        DEFAULT => 'root',
    },
    'db_password'     => {
        ARGCOUNT => ARGCOUNT_ONE,
        DEFAULT => '',
    },
);

$config->file('includes/config.txt');

# Setup the connection (does not connect yet)
my $connection = FB::DB->connection('dbi:mysql:fb:' . $config->db_host . ':' . $config->db_port, $config->db_username, $config->db_password);
#my $connection = FB::DB->connection('dbi:mysql:fb:127.0.0.1','root','');

package FB::DB::User;
use base 'FB::DB';
__PACKAGE__->table('user');
__PACKAGE__->columns(Primary => qw/user_id/);
__PACKAGE__->columns(Essential => qw/identifier name email max_forms is_active/);
__PACKAGE__->has_many(forms => [FB::DB::User_Form => 'form'], { order_by => 'form DESC' });

__PACKAGE__->set_sql('non_deleted_forms' => qq{select f.form_id from form as f join user_form as uf on (f.form_id = uf.form) and uf.user = ? and f.is_deleted = 0 order by uf.form DESC;});

sub non_deleted_forms {
  my $instance = shift;
  my $sth = FB::DB::User->sql_non_deleted_forms;
  $sth->execute($instance->user_id);
  return FB::DB::Form->sth_to_objects($sth);
}


package FB::DB::User_Form;
use base 'FB::DB';
__PACKAGE__->table('user_form');
__PACKAGE__->columns(Primary => qw/user form/);
__PACKAGE__->columns(Essential => qw/role/);
__PACKAGE__->has_a(user => 'FB::DB::User');
__PACKAGE__->has_a(form => 'FB::DB::Form');

package FB::DB::Form;
use base 'FB::DB';
__PACKAGE__->table('form');
__PACKAGE__->columns(Primary => qw/form_id/);
__PACKAGE__->columns(
    Essential => qw/form_id path url name description is_live is_deleted date_deleted deleted_by template css templates_path date_created theme confirmation_method
    confirmation_text confirmation_url confirmation_email submission_method submission_email submission_email_csv submission_email_subject submission_email_sender has_submission_database total_submissions total_database_submissions last_submission_date creator can_be_continued confirm_before_submit/);
__PACKAGE__->has_many(
    nodes => FB::DB::Node, 'form_id', { order_by => 'sort_order' });
#__PACKAGE__->has_many(users => [FB::DB::User_Form => 'user'], { order_by => 'user DESC' });

__PACKAGE__->set_sql('users' => qq{select u.user_id from user as u join user_form as uf on (u.user_id = uf.user) and uf.form = ? order by u.identifier;});

sub users {
  my $instance = shift;
  my $sth = FB::DB::Form->sql_users;
  $sth->execute($instance->form_id);
  return FB::DB::User->sth_to_objects($sth);
}

__PACKAGE__->set_sql('update_submission_count' => qq{update form set total_submissions = total_submissions + 1, last_submission_date = NOW() where form_id = ?});

sub update_submission_count {
  my $class = shift;
  my $form_id = shift;
  my $sth = FB::DB::Form->sql_update_submission_count;
  $sth->execute($form_id);
}

__PACKAGE__->set_sql('update_database_submission_count' => qq{update form set total_database_submissions = total_database_submissions + 1, last_submission_date = NOW() where form_id = ?});

sub update_database_submission_count {
  my $class = shift;
  my $form_id = shift;
  my $sth = FB::DB::Form->sql_update_database_submission_count;
  $sth->execute($form_id);
}

__PACKAGE__->set_sql('set_database_submission_count' => qq{update form set total_database_submissions = ? where form_id = ?});

sub set_database_submission_count {
  my $class = shift;
  my $form_id = shift;
  my $submission_count = shift;
  my $sth = FB::DB::Form->sql_set_database_submission_count;
  $sth->execute($submission_count, $form_id);
}


__PACKAGE__->set_sql('count_paths' => qq{select count(*) from form where is_deleted != 1 and path = ? and form_id != ?});

sub count_paths {
  my $class = shift;
  my $path  = shift;
  my $form_id_to_ignore = shift;
  my $sth = FB::DB::Form->sql_count_paths;
  $sth->execute($path, $form_id_to_ignore);
  my $result_ref = $sth->fetchrow_arrayref;
  return $result_ref->[0];
}

__PACKAGE__->set_sql('set_to_deleted' => qq{update __TABLE__ SET date_deleted = NOW(), is_deleted = 1, deleted_by = ? where __IDENTIFIER__});

sub set_to_deleted {
  my $instance = shift;
  my $user     = shift;
  my $sth = FB::DB::Form->sql_set_to_deleted($user);
  $sth->execute($user, $instance->form_id);
  return;
}

package FB::DB::Node;
use base 'FB::DB';
__PACKAGE__->table('node');
__PACKAGE__->columns(Primary => qw/node_id/);
__PACKAGE__->columns(Essential => qw/form_id element_id node_type sort_order/);

package FB::DB::Collection;
use base 'FB::DB';
__PACKAGE__->table('collection');
__PACKAGE__->columns(Primary => qw/collection_id/);
__PACKAGE__->columns(Essential => qw/label class type template is_required name is_autofilled/);
__PACKAGE__->has_many(elements => ['FB::DB::Collection_Element' => 'element'], { order_by => 'sort_order' });

package FB::DB::Collection_Element;
use base 'FB::DB';
__PACKAGE__->table('collection_element');
__PACKAGE__->columns(Primary => qw/collection element/);
__PACKAGE__->columns(Essential => qw/sort_order/);
__PACKAGE__->has_a(collection => 'FB::DB::Collection');
__PACKAGE__->has_a(element => 'FB::DB::Element');

package FB::DB::Element;
use base 'FB::DB';
__PACKAGE__->table('element');
__PACKAGE__->columns(Primary => qw/element_id/);
__PACKAGE__->columns(Essential => qw/label name class type value template itemset is_required is_required_in_collection is_autofilled/);
# can we grab these items going through itemset?
#__PACKAGE__->has_many(items => ['FB::DB::Element_Item' => 'item'], { order_by => 'sort_order' });
__PACKAGE__->has_a(itemset => 'FB::DB::ItemSet');

#package FB::DB::Element_Item;
#use base 'FB::DB';
#__PACKAGE__->table('element_item');
#__PACKAGE__->columns(Primary => qw/element_item_id/);
#__PACKAGE__->columns(Essential => qw/element item sort_order/);
#__PACKAGE__->has_a(item => 'FB::DB::Item');
#__PACKAGE__->has_a(element => 'FB::DB::Element');

# ItemSets are collections of items, such as a list of countries
# shown in a drop down list. Every select has at least one itemset
# and can have more than one. In that case, think of them as
# optgroups.

package FB::DB::ItemSet;
use base 'FB::DB';
__PACKAGE__->table('itemset');
__PACKAGE__->columns(Primary => qw/itemset_id/);
__PACKAGE__->columns(Essential => qw/label is_custom/);
__PACKAGE__->has_many(items => FB::DB::Item, itemset_id, { order_by => 'sort_order' });


__PACKAGE__->set_sql('count_elements' => qq{select count(1) from element where itemset = ?});

sub count_elements {
  my $class = shift;
  my $itemset_id = shift;
  my $sth = FB::DB::ItemSet->sql_count_elements;
  $sth->execute($itemset_id);
  my $result_ref = $sth->fetchrow_arrayref;
  return $result_ref->[0];
}

# Items are individual choices that can be made in select elements
# They can be represented as radio buttons, checkboxes or list items
# They belong to just one itemset and are sorted
# item_id    : unique ID for the item
# itemset    : the unique ID for the itemset this item belongs to
# label      : the text shown to the user so that a choice can be made
# value      : the value submitted when the choice is made (for now, same as label)
# sort_order : the order in which the items are to appear in the itemset

package FB::DB::Item;
use base 'FB::DB';
__PACKAGE__->table('item');
__PACKAGE__->columns(Primary => qw/item_id/);
__PACKAGE__->columns(Essential => qw/itemset_id label value sort_order/);


1;

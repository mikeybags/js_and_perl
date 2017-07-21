# I had some fun with this and went a little beyond what the instructions asked for. 
# To get the basic functionality that the specifications said, the print_data() function takes care of that. 
# I was curious about dynamically inserting the data, so I wrote this so that if the table doesn't exist at first, 
# it creates the table and inserts the data (therefore not duplicating the data), and then prints it. 

use DBI;
use strict;

# Set up database connection
my $driver = "SQLite";
my $database = "db.sqlite3";
my $dsn = "DBI:$driver:$database";
my $dbh = DBI->connect("DBI:$driver:$database", "", "",
                    { RaiseError => 1, AutoCommit => 0});

print "Opened database successfully!\n";

# Check if user table exists. If it doesn't, create it and insert the data. If it does, just print the data.
if (does_table_exist($dbh, 'user')) {
    print_data();
} else {
    $dbh->do("CREATE TABLE user (first_name varchar(50), last_name varchar(50), home varchar(50))");
    insert_data();
    print_data();
}

$dbh->disconnect();

sub insert_data {
 # Data to place into database 
    my @table_data = (
        { first_name => 'Rose', last_name => 'Tyler', home => 'Earth' },
        { first_name => 'Zoe', last_name => 'Heriot', home => 'Space Station W3'},
        { first_name => 'Jo', last_name => 'Grant', home => 'Earth'},
        { first_name => 'Leela', last_name => undef, home => 'Unspecified'},
        { first_name => 'Romana', last_name  => undef, home => 'Gallifrey'},
        { first_name => 'Clara', last_name => 'Oswald', home => 'Earth'},
        { first_name => 'Adric', last_name => undef, home => 'Alzarius'},
        { first_name => 'Susan', last_name => 'Foreman', home => 'Gallifrey'}
    );

    # Insert data into table
    my $insert_statement = qq(INSERT INTO user VALUES(?, ?, ?));
    my $insert = $dbh->prepare($insert_statement)
        or die "Couldn't prepare query: " . $dbh->errstr;

    foreach my $elem (@table_data) {
        $insert->execute($elem->{first_name}, $elem->{last_name} || 'null', $elem->{home})
            or die "Couldn't execute query: " . $DBI::errstr;
    }

    $dbh->commit();
}

sub print_data {
    # Read data from table
    my $select_statement = qq(SELECT * FROM user);
    my $sth = $dbh->prepare($select_statement)
        or die "Couldn't prepare query: " . $dbh->errstr;
    $sth->execute()
        or die "Couldn't execute query: " . $dbh->errstr;

    # Print column headers/names, format a little bit
    my $fields = join(' ', @{ $sth->{NAME_uc} });
    $fields = join(' ', split(/_/, $fields));
    print "$fields\n";

    # Print data from table, and add a little bit of formatting to layout
    while( my @row_data = $sth->fetchrow_array() ) {
        my $first_name = $row_data[0];
        if (length($first_name) < 11) {
            my $extra_spaces = ' ' x (10 - length($first_name));
            $first_name = $first_name . $extra_spaces;
        }
        my $last_name = $row_data[1];
        if (length($last_name) < 10) {
            my $extra_spaces = ' ' x (9 - length($last_name));
            $last_name = $last_name . $extra_spaces;
        }
        my $home = $row_data[2];
        print "$first_name $last_name $home\n";
    }
}

sub does_table_exist {
    my ($dbh,$table_name) = @_;

    my $sth = $dbh->table_info(undef, undef, $table_name, 'TABLE');

    $sth->execute;
    my @info = $sth->fetchrow_array;
    my $exists = scalar @info;
    return $exists;
}


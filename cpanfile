requires 'perl', '5.008005';

# requires 'Some::Module', 'VERSION';

requires 'Data::Dumper';

on test => sub {
    requires 'Test::More', '0.88';
};

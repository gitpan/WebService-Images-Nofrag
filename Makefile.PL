use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'WebService::Images::Nofrag',
    AUTHOR              => 'Franck Cuny <franck.cuny@gmail.com>',
    VERSION_FROM        => 'lib/WebService/Images/Nofrag.pm',
    ABSTRACT_FROM       => 'lib/WebService/Images/Nofrag.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'WebService-Images-Nofrag-*' },
);

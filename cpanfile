requires "DateTime" => "0.72";
requires "DateTime::Format::Epoch" => "0.13";
requires "DateTime::Format::Epoch::Unix" => "0";
requires "DateTime::Format::RFC3339" => "0";
requires "Dist::Data" => "0.002";
requires "File::Copy" => "0";
requires "File::Path" => "2.08";
requires "File::Spec::Functions" => "3.33";
requires "IO::File" => "1.14";
requires "IO::Zlib" => "1.10";
requires "Moo" => "0.009013";
requires "Moo::Role" => "0";

on 'test' => sub {
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "File::Temp" => "0.22";
  requires "FindBin" => "0";
  requires "Test::More" => "0.90";
  requires "strict" => "0";
  requires "warnings" => "0";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "0";
};

on 'develop' => sub {
  requires "Test::CPAN::Changes" => "0.19";
  requires "Test::Code::TidyAll" => "0.50";
  requires "Test::More" => "0.96";
  requires "Test::Synopsis" => "0";
  requires "strict" => "0";
  requires "warnings" => "0";
};

on 'develop' => sub {
  recommends "Dist::Zilla::PluginBundle::Git::VersionManager" => "0.007";
};

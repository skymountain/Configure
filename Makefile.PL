use inc::Module::Install;

name 'Configure';
author 'Taro Sekiyama';
version '0.01';

requires 'YAML::XS';

auto_install;
WriteAll;

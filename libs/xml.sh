#!/bin/bash

# Purpose: Deal with XML files
# Author : Anh K. Huynh
# Date   : 2014
# License: MIT

xml_pretty() {
  perl -e '
    use XML::LibXML;
    use XML::LibXML::PrettyPrint;
    my $document = XML::LibXML->new->parse_file("-");
    my $pp = XML::LibXML::PrettyPrint->new(indent_string => " ");
    $pp->pretty_print($document); # modified in-place
    print $document->toString;
  '
}

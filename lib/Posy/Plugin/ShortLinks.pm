package Posy::Plugin::ShortLinks;

#
# $Id: ShortLinks.pm,v 1.5 2005/03/07 15:10:14 blair Exp $
#

use 5.006;
use strict;
use warnings;

=head1 NAME

Posy::Plugin::ShortLinks - Transform keywords into links

=head1 VERSION

This document describes Posy::Plugin::ShortLinks version B<0.2>.

=cut

our $VERSION = '0.2';

=head1 SYNOPSIS

  @plugins = qw(
    Posy::Core
    ...
    Posy::Plugin::ShortLinks
  );
  @entry_actions = qw(header
    ...
    parse_entry
    shortlinks
    render_entry
    ...
  );

  And in $config_dir/plugins/shortlinks:

    CPAN:http://search.cpan.org
    devclue:http://devclue.com
    
  And in one's entry files:

    {{link:CPAN}} and {{link:devclue}} 


=head1 DESCRIPTION

This modules replaces all properly formatted keywords within one's
entry files with full links.

=head1 INTERFACE

=cut

my %links;

=head2 init()

  $self->init()

Reads the short links configuration file.

=cut
sub init {
  my $self = shift;
  $self->SUPER::init();

  # read configuration file
  my $cf = File::Spec->catfile($self->{config_dir}, 'plugins',
                               'shortlinks');
  $self->debug(3, "ShortLinks: Reading $cf");
  %links = $self->read_config_file($cf);
} # init()

=head2 shortlinks()

  $self->shortlinks($flow_state, $current_entry, $entry_state)

Alters C<$current_entry->{body}> by adding proper links whenever a
shortened link is encountered.

=cut
sub shortlinks {
  my ($self, $flow_state, $current_entry, $entry_state) = @_;
  my $body = $current_entry->{body};
  if ($body) {
    # TODO The pattern should probably be configurable
    $body =~ s|{{link:(.+?)}}|$self->_create_link($1)|ego; 
    $current_entry->{body} = $body;
  }
  1;
} # shortlinks()

sub _create_link {
  my ($self, $link) = @_;
  if ($link and $links{$link}) {
    $link = '<a href="' . $links{$link} . '">' . $link . '</a>';
  }
  return $link;
} # _get_link();

=head1 SEE ALSO

L<Perl>, L<Posy>

=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to
C<bug-Posy-Plugin-ShortLinks@rt.cpan.org> or through the web interface at 
L<http://rt.cpan.org>.

=head1 AUTHOR

blair christensen., E<lt>blair@devclue.comE<gt>

<http://devclue.com/blog/code/posy/Posy::Plugin::ShortLinks/>

=head1 COPYRIGHT AND LICENSE

Copyright 2005 by blair christensen.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=head1 DISCLAIMER OF WARRANTY                                                                                               

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO
WARRANTY FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE
LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS
AND/OR OTHER PARTIES PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE
OF THE SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE,
YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA
BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES
OR A FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY
OF SUCH DAMAGES.

=cut

1;


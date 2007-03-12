package WebService::Images::Nofrag;

use warnings;
use strict;
use Carp;
use WWW::Mechanize;
use base qw(Class::Accessor::Fast);

WebService::Images::Nofrag->mk_accessors(qw(thumb image url));

=head1 NAME

WebService::Images::Nofrag - upload an image to http://pix.nofrag.com

=head1 VERSION

Version 0.04

=cut

our $VERSION = '0.05';
our $SITE    = 'http://pix.nofrag.com/';

=head1 SYNOPSIS

Quick summary of what the module does.

	my $pix = WebService::Images::Nofrag->new();
	$pix->upload('/path/to/the/file');
    
	print "URL : " . $pix->url . "\n";    # print the url of the page
  print "image : " . $pix->image . "\n";# print the url of the image
  print "thumb : " . $pix->thumb . "\n";# print the url of the thumb
    
=cut

=head2 upload

	upload an image to http://pix.nofrag.com
	
	If a filename is not passed, we exit.
	
	Set 3 accessors, thumb image & url, with the url to the different
	data.
	
=cut

sub upload {
	my ($self, $file) = @_;

	if ( !defined $file || !-r $file ) {
		croak "\tProblem, can't read this file\n";
	}

	$self->{options} = shift;
	$self->{mech}    = WWW::Mechanize->new();
	
	$self->{mech}->get($SITE);
	$self->{mech}->field( 'monimage', $file );

	$self->{mech}->click_button(
		input => $self->{mech}->current_form()->find_input( undef, "submit" )
	);

	if ( $self->{mech}->content =~ /Impossible to process this picture!/ ) {
		$self->url("none");
    $self->image("none");
    $self->thumb("none");
		croak "\tProblem, can't upload this file\n";
	}

	if ( $self->{mech}->res->is_success ) {
		my $content = $self->{mech}->content;
		$content =~ /\[url=(http:\/\/pix\.nofrag\.com\/.*\.html)\]/;
		$self->url($1);
		$content =~ /\[img\](http:\/\/pix\.nofrag\.com\/.*)\[\/img\]/;
		$self->image($1);
		my @img = $self->{mech}->find_all_images();
		foreach my $img (@img){
			last if $self->thumb;
			if ($img->url =~ /^$SITE/){
				$self->thumb($img->url);
			}
		}
	} else {
		croak "Problem, can't upload this file.";
	}
}


=head1 AUTHOR

Franck Cuny, C<< <franck.cuny at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-webservice-images-nofrag at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WebService-Images-Nofrag>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc WebService::Images::Nofrag

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WebService-Images-Nofrag>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WebService-Images-Nofrag>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WebService-Images-Nofrag>

=item * Search CPAN

L<http://search.cpan.org/dist/WebService-Images-Nofrag>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2006 Franck Cuny, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;

__END__
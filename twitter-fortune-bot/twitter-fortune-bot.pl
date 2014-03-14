#!/usr/bin/env perl

#  unix-fortune-bot.pl
#  Author: William Woodruff
#  ------------------------
#  Posts a fortune generated by the 'fortune' utility to Twitter every 15 minutes
#  Uses the REST 1.1 API and requires OAuth.
#  Depends on Net::Twitter.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use Net::Twitter;

my $consumer_key = "";
my $consumer_secret = "";
my $token = "";
my $token_secret = "";

my $twitter = Net::Twitter->new(traits => [qw/API::RESTv1_1/], consumer_key => $consumer_key, consumer_secret => $consumer_secret, access_token => $token, access_token_secret => $token_secret, ssl => 1);

while (1)
{
	my $fortune = `fortune -s -n 140`;
	my $result = $twitter->update($fortune);
	sleep(900);
}
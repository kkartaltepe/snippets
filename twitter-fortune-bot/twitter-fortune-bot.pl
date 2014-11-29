#!/usr/bin/env perl

#  twitter-fortune-bot.pl
#  Author: William Woodruff
#  ------------------------
#  Posts a fortune generated by the 'fortune' utility to Twitter
#  Uses the REST 1.1 API and requires OAuth.
#  Depends on Net::Twitter, and on the presence of the 'fortune' program.
#  ------------------------
#  This code is licensed by William Woodruff under the MIT License.
#  http://opensource.org/licenses/MIT

use strict;
use warnings;

use Net::Twitter;

my $consumer_key = %ENV{TWITTER_CONSUMER_KEY};
my $consumer_secret = %ENV{TWITTER_CONSUMER_SECRET};
my $token = %ENV{TWITTER_TOKEN};
my $token_secret = %ENV{TWITTER_TOKEN_SECRET};

my $twitter = Net::Twitter->new(traits => [qw/API::RESTv1_1/], consumer_key => $consumer_key, consumer_secret => $consumer_secret, access_token => $token, access_token_secret => $token_secret, ssl => 1);


my $fortune = `fortune -s -n 140`;
my $result = $twitter->update($fortune);

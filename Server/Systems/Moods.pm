package Moods;

use HTML::Entities;
use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleUpdateMood($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $strMood = decode_entities($arrData[4]);
       if (length($strMood) <= 100) {
           $objClient->{mood} = $strMood;
           $self->{child}->{modules}->{mysql}->updateTable('users', 'mood', $strMood, 'ID', $objClient->{ID});
           $objClient->sendXT(['umo', $objClient->{ID}, $strMood]);
       }
}

1;

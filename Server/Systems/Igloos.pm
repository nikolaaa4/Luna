package Igloos;

use strict;
use warnings;

use Method::Signatures;

method new($resChild) {
       my $obj = bless {}, $self;
       $obj->{child} = $resChild;
       return $obj;
}

method handleAddFurniture($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intFurn = $arrData[5];
       $objClient->addFurniture($intFurn);
}

method handleUpdateIgloo($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intIgloo = $arrData[5];
       $objClient->updateIgloo($intIgloo);
}

method handleAddIgloo($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intIgloo = $arrData[5];
       $objClient->addIgloo($intIgloo);
}

method handleUpdateFloor($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intFloor = $arrData[5];
       $objClient->updateFloor($intFloor);
}

method handleUpdateMusic($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intMusic = $arrData[5];
       $objClient->updateMusic($intMusic);
}

method handleGetIglooDetails($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $intPID = $arrData[5];
       return if (!int($intPID));
       my $arrInfo = $self->{child}->{modules}->{mysql}->fetchColumns("SELECT `igloo`, `music`, `floor`, `furniture` FROM igloos WHERE `ID` = '$intPID'");
       my $intIgloo = $arrInfo->{igloo};
       my $intMusic = $arrInfo->{music};
       my $intFloor = $arrInfo->{floor};
       my $strFurn = $arrInfo->{furniture};
       $objClient->write('%xt%gm%-1%' . $intPID . '%' . $intIgloo . '%' . $intMusic . '%' . $intFloor . '%' .  ($strFurn ? $strFurn : '') . '%');
}

method handleGetOwnedIgloos($strData, $objClient) {
       my $strIgloos = join('|', @{$objClient->{ownedIgloos}});
       $objClient->sendXT(['go', '-1', $strIgloos]);
}

method handleOpenIgloo($strData, $objClient) {
       $objClient->openIgloo;
}

method handleCloseIgloo($strData, $objClient) {
       $objClient->closeIgloo;
}

method handleGetOwnedFurniture($strData, $objClient) {
       my $strFurns = join('%', map { $_ . '|' . $objClient->{ownedFurns}->{$_}; } keys %{$objClient->{ownedFurns}});
       $objClient->write('%xt%gf%-1%' . ($strFurns ? $strFurns : '%'));
}

method handleGetFurnitureRevision($strData, $objClient) {
       my @arrData = split('%', $strData);
       my $strFurns = '';
       while (my ($intKey, $strValue) = each(@arrData)) {
              if ($intKey > 4) {
                  $strFurns .= $strValue . ',';
              }
       }
       $objClient->updateFurniture($strFurns);
}

method handleGetOpenedIgloos($strData, $objClient) {
       my $strIgloos = $self->loadIglooMap;
       $objClient->write('%xt%gr%-1%' . ($strIgloos ? $strIgloos : '')); 	 
}

method loadIglooMap {
       my $strMap = join('%', map { $_ . '|' . $self->{child}->{igloos}->{$_}; } keys %{$self->{child}->{igloos}});
       return $strMap;
}

1;

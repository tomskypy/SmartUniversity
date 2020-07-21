# Smart University
> Open-source iOS clean-code app with advanced features for indoor navigational purposes.

[![Build Status](https://app.bitrise.io/app/58c3b91ee657d1ba/status.svg?token=1fuC_2q6ruMNhofSOEAhHA&branch=master)](https://app.bitrise.io/app/58c3b91ee657d1ba)
[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/Naereen/StrapDown.js/blob/master/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](https://developer.apple.com/ios/)
<a href="https://developer.apple.com/swift/">
<img src="https://img.shields.io/badge/Swift-5-orange.svg"
alt="Swift" />
</a>

Smart University's primary purpose is navigation aiding in various indoor [Masaryk University](https://www.muni.cz)'s environments. By incorporating an idea of known uniquely identifiable locations – QR Points – and utilizing the university's [munimap](https://maps.muni.cz/munimap/) component combined with advanced augmented reality visualization, the app enables users to navigate lesser-known grounds with much more ease.

## Features

- [x] munimap WebView Map Integration
- [x] QR Point Scanning
- [x] AR Indoor Locator

QR Point is a concept of precisely placed uniquely identifiable posters, which, when scanned, can provide the application with access to all the pre-defined data about the location, effectively enabling convenient indoor localization. This feature requires a Smart University poster to be placed in a particular location with a specific scannable QR code. 

The ARKit implementation, meant to aid user's orientation in 3D space, is capable of visualizing a scalable and specifically placeable AR room representation. The representation is in the form of mesh connecting room's corners to be easily noticeable, but not obstructing the AR view. Similarly to localization, this feature utilizes the QR Point poster, which is automatically recognized within the ARKit, with its position used to place the room meshes in their precise locations.

## Requirements

- iOS 13.2+
- Internet access
- A bit of curiosity :)

## How to Install

The first (kinda) public release of Smart University is here! Just simply click the link bellow and thanks in advance for giving it a try:

[Access the TestFlight public beta.](https://testflight.apple.com/join/HOHRusOW) 

(You will need a [QR Point](https://drive.google.com/file/d/1LoXy8xsZBLievxNNZaFmFy2huIBiQU5x/view?usp=sharing) to operate the app at least in "demo" mode. In a real production environment, they are very precisely placed.)

## Meta

Tomáš Skýpala – [in/tomas-skypala](https://www.linkedin.com/in/tomas-skypala/)

Distributed under the MIT License. See ``LICENSE`` for more information.

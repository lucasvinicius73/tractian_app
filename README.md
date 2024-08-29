# Challenge Tractian Mobile
Challenge proposed by Tractian for the position of Mobile Software Engineer. The challenge consists of creating a Flutter application for managing and visualizing a company's assets.

[Challenge Link](https://github.com/tractian/challenges/blob/main/mobile/README.md)

## Libraries used:

- [http: ^1.2.2](https://pub.dev/packages/http) 
- [string_similarity: ^2.1.1](https://pub.dev/packages/string_similarity)
- [super_sliver_list: ^0.4.1](https://pub.dev/packages/super_sliver_list)

## Project standard:

This project was built using the MVC(Model,View,Controller) format.
The challenge API was consumed using the service format, where the information was handled using the Models built in the application.

The logical part of the application was built in the Controller class, which received the data from the Service and built it in the format needed to send it to the View

In the View, the items were displayed in a tree format as described in the challenge, using recursion to assemble the items based on the number of children

## API consumed:
- API: [fake-api.tractian.com](fake-api.tractian.com)

## Video Result:


https://github.com/user-attachments/assets/c843057a-af52-4948-bf92-db2964f97281


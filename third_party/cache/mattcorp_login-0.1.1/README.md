# MattCorp Login (for Flutter)

MattCorp Id authentication for Flutter projects.

## About

This package is a **work-in-progress** library to allow Flutter projects to easily use MattCorp Id for secure authentication.
It is **not recommended for use** at this time.

## Usage

1) Import the package
2) Create a new `MattCorpLogin` instance, passing in the correct `client` named parameter
3) Call the asynchronous `login` method on the `MattCorpLogin` instance
4) This will return a JWT (or an error) as a string
5) Consume this JWT as normal (e.g. the same as your web implementation)
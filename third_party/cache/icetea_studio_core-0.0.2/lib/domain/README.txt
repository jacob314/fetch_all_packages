- Contains the data and business logics for the application
- Contains the deepest part of the application in terms of dependency
- Contains Event Delegates used by the outside worlds to respond to events that happen within the domain
- Defines the workflows which can be triggered by the business logics defined in the domain (i.e. Account Validation, Order Transaction, etc...)

Contents:
 - /contants: Contains the all of the constants used across the domain
 - /entities: Defines the data structures for the data moved across the domain
   NOTE: Currently, these entities only contain data. We will explore the possibilities of adding functionalities to these entities later.

 - /interfaces: Defines the interfaces the Domain use to communicate with the outside world (e.g. Repositories, UI/Presentation Layer)
   NOTE: This layer cannot communicate with the outside layers directly. By exposing interfaces that can be implemented by the outside layers, this layer can effectively communicate with them.
 - /services: Defines the business logics for the different use cases of the domain. These are also known as interactors
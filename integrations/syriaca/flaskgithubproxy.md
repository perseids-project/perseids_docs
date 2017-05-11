# Flask GitHub Proxy
Authors:
Thibault Clérice @PonteIneptique
Bridget Almas @balmas

Flask Github Proxy (FGP) is a middleware service  that offers a simple  means to transmit data from a web application to a GitHub data repository. FGP takes advantage of traditional distributed git workflows, enabling human verification of proposed changes made to a mirror repository through pull requests. 

FGP is designed for use with third party applications that operate on data and want to be able to contribute or return that data to GitHub repositories without being granted write privileges.  The FGP provides a simple API through which applications can submit data via RESTful requests, and FGP handles the more complex interactions with the GitHub API. The FGP provides a technical benefit by reducing the effort needed for client applications wishing to take advantage of complex GitHub workflows.

Coupled with an application like Perseids that provides a full editorial board-based review workflow, it allows for a variety of different data life cycles. Teams of scholars can work collaboratively on proposed changes to data, or new data sets.,Once agreement is reached, Perseids uses the FGP to send data to GitHub repositories where the data curator or web maintainer can then control the regularity of data change by approving the third-party upgrade. 

FGP is meant to be used as a web service behind firewalls, ie. FGP should never be accessible by the public but instead  act as an hidden service behind multiple applications. The application is built as a Flask extension and blueprint creator, Flask being a popular light python web framework that enables rapid development of  web applications. It has the simplest input data model possible and offers a strong error handling system reproducing messages that can arise from github API communications. It has built in methods that allow for direct communication with GitHub which per se allows for other development. It can also operate directly on the target repository if the mirror repository workflow is not needed. 
In the coming phase of the project we would take steps to further enable reuse of FGP, by enhancing the documentation and the ease with which it can be configured. Currently, each time a project needs to be added to the FGP system, an administrator or a developer must make a change to the python driver code. We want to remove this limitation by backing FGP with a small database system allowing for repositories to be managed using its own API.

For example,  a department might host FGP as a microservice for a set of its own web applications. Right now, adding a new destination repository requires touching code and restarting the service. What we propose is that each client application can, through secured methods, add or delete target data repositories to FGP through a simple API.

For sustainability, we need to ensure that the code works through the use of unit tests and workflow tests. If wished for, it could be accompanied by a simple client library to reuse FGP in the context of Python (web) applications..

# Distributed Systems Simulator

This blog explores the Java-based Distributed Simulator program I've created specifically for simulating distributed systems protocols, offering both built-in implementations of common algorithms and an extensible framework that allows researchers and practitioners to implement and test their own custom protocols within the simulation environment.

Note, this is an older project of mine, which I modernized lately with the help of AI.

<< template::inline::toc

## Motivation

Distributed systems are notoriously complex, with intricate interactions between multiple nodes, network partitions, and failure scenarios that can be difficult to understand and debug in production environments. A distributed systems simulator provides an invaluable learning tool that allows developers and students to experiment with different architectures, observe how systems behave under various failure conditions, and gain hands-on experience with concepts like consensus algorithms, replication strategies, and fault tolerance—all within a controlled, repeatable environment. By abstracting away the operational overhead of managing real distributed infrastructure, simulators enable focused exploration of system design principles and help bridge the gap between theoretical knowledge and practical understanding of how distributed systems actually work in the real world.

In the literature, one can find many different definitions of a distributed system. Many of these definitions differ from each other, making it difficult to find a single definition that stands alone as the correct one. Andrew Tanenbaum and Maarten van Steen chose the following loose characterization for describing a distributed system:

> "A distributed system is a collection of independent computers that appears to its users as a single coherent system" - Andrew Tanenbaum

The user only needs to interact with the local computer in front of them, while the software of the local computer ensures smooth communication with the other participating computers in the distributed system.

This thesis aims to make it easier for users to view distributed systems from a different perspective. Here, the viewpoint of an end user is not adopted; instead, the functional methods of protocols and their processes in distributed systems should be made comprehensible, while simultaneously making all relevant events of a distributed system transparent.

To achieve this goal, a simulator was developed, particularly for teaching and learning purposes at the University of Applied Sciences Aachen. With the simulator, protocols from distributed systems with their most important influencing factors can be replicated through simulations. At the same time, there is ample room for personal experiments, with no restriction to a fixed number of protocols. It is therefore important that users are enabled to design their own protocols.

## Fundamentals

For basic understanding, some fundamentals are explained below. A deeper exploration will follow in later chapters.

### Client/Server Model

```
┌─────────────────────────────────────────────┐
│                                             │
│     ┌────────┐         ┌────────┐           │
│     │ Client │◄-------►│ Server │           │
│     └────────┘         └────────┘           │
│                                             │
│         Sending of Messages                 │
│                                             │
└─────────────────────────────────────────────┘

Figure 1.1: Client/Server Model
```

The simulator is based on the client/server principle. Each simulation typically consists of a participating client and a server that communicate with each other via messages (see Fig. 1.1). In complex simulations, multiple clients and/or servers can also participate.

### Processes and Their Roles

A distributed system is simulated using processes. Each process takes on one or more roles. For example, one process can take on the role of a client and another process the role of a server. The possibility of assigning both client and server roles to a process simultaneously is also provided. A process could also take on the roles of multiple servers and clients simultaneously. To identify a process, each one has a unique Process Identification Number (PID).

### Messages

In a distributed system, it must be possible to send messages. A message can be sent by a client or server process and can have any number of recipients. The content of a message depends on the protocol used. What is meant by a protocol will be covered later. To identify a message, each message has a unique Message Identification Number (NID).

### Local and Global Clocks

In a simulation, there is exactly one global clock. It represents the current and always correct time. A global clock never goes wrong.

Additionally, each participating process has its own local clock. It represents the current time of the respective process. Unlike the global clock, local clocks can display an incorrect time. If the process time is not globally correct (not equal to the global time, or displays an incorrect time), then it was either reset during a simulation, or it is running incorrectly due to clock drift. The clock drift indicates by what factor the clock is running incorrectly. This will be discussed in more detail later.

```
┌─────────────────────┐     ┌─────────────────────┐
│    Process 1        │     │    Process 2        │
│                     │     │                     │
│ ┌─────────────────┐ │     │ ┌─────────────────┐ │
│ │Server Protocol A│ │     │ │Client Protocol A│ │
│ └─────────────────┘ │     │ └─────────────────┘ │
│                     │     │                     │
│ ┌─────────────────┐ │     └─────────────────────┘
│ │Client Protocol B│ │     
│ └─────────────────┘ │     ┌─────────────────────┐
│                     │     │    Process 3        │
└─────────────────────┘     │                     │
                            │ ┌─────────────────┐ │
                            │ │Server Protocol B│ │
                            │ └─────────────────┘ │
                            │                     │
                            └─────────────────────┘

Figure 1.2: Client/Server Protocols
```

In addition to normal clocks, vector timestamps and Lamport's logical clocks are also of interest. For vector and Lamport times, there are no global equivalents here, unlike normal time. Concrete examples of Lamport and vector times will be covered later in Chapter 3.11.1.

### Events

A simulation consists of the sequential execution of finitely many events. For example, there can be an event that causes a process to send a message. A process crash event would also be conceivable. Each event occurs at a specific point in time. Events with the same occurrence time are executed directly one after another by the simulator. However, this does not hinder the simulator's users, as events are executed in parallel from their perspective.

### Protocols

A simulation also consists of the application of protocols. It has already been mentioned that a process can take on the roles of servers and/or clients. For each server and client role, the associated protocol must also be specified. A protocol defines how a client and a server send messages, and how they react when a message arrives. A protocol also determines what data is contained in a message. A process only processes a received message if it understands the respective protocol.

In Figure 1.2, 3 processes are shown. Process 1 supports protocol "A" on the server side and protocol "B" on the client side. Process 2 supports protocol "A" on the client side and Process 3 supports protocol "B" on the server side. This means that Process 1 can communicate with Process 2 via protocol "A" and with Process 3 via protocol "B". Processes 2 and 3 are incompatible with each other and cannot process messages received from each other.

Clients cannot communicate with clients, and servers cannot communicate with servers. For communication, at least one client and one server are always required. However, this restriction can be circumvented by having processes support a given protocol on both the server and client sides (see Broadcast Protocol in Chapter 3.3).


E-Mail your comments to `paul@nospam.buetow.org`

=> ../ Back to the main site

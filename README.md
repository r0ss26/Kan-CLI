# Kan-CLI

## Introduction

Kanban boards are widely used within project management for tracking the progress of tasks. Such boards allow individuals or teams to organise tasks into specific groups to visualise and share progress. Kan-CLI implements this functionality within a command line environment.

### Components of a Kanban board

Kanban boards are made up of a variety of elements which come together to form a workflow. To make up this workflow a Kanban board comprises a hierarchical relationship between "Boards", "Lists" and "Cards".  Typically a board will be used to represent a project. Lists can be used to organise tasks into categories, while cards represent indivudual tasks. While in agile development cards often represent user stories, Kanban boards are extremely flexible and can be used for managing any type of project or task. (https://www.atlassian.com/agile/kanban/boards)

## Purpose & Scope

### What does Kan-CLI do?

Kan-CLI will allow users to create boards, lists and cards. Users will be able to place cards within different lists as well as set limits for the number of cards within a list.

### Why make a CLI Kanban board?

Kan-CLI aims to provide users with a distraction free environment, providing the ideal environment for getting offline tasks done, without the distraction of an internet GUI. 

### Who is the target audience?

Since Kan-CLI does not require an internet connection, it is ideal for writers or anyone who wants to remove the temptation to be distracted by timewasting websites. 

### How will users interact with Kan-CLI?

When a user runs the Kan-CLI command they will be prompted to create a board. Once the user has created a board they can then input a number of lists to categorize their tasks. The user can then create individual cards which they can associate with a list. This association can be changed as the user progresses through their work flow.

## Features

### Create Boards

### Create Lists

### Create Cards

### Categorize Cards Within Lists

## User Interaction

## Implementation Plan

### Boards

There will be board class and a board object will be created when the user runs the program and is prompted to create a board. The board class will have methods for adding lists and removing lists, it will also have a title and a creation date.

### Lists

There will be a List class, list objects will be created when the user is prompted to make lists. There will also be an option to add more lists to the board later on.

### Cards

There will be a Card class, card objects will be created when the user is prompted. There will be an option to add more cards later on. All cards will be associated with a list at creation and will contain a method for moving cards to different lists.

 


# Recipe App Be (Rails)

## Overview
This project is a proof-of-concept API built with **Ruby on Rails 7.1.5.1** (using **Ruby 3.2.2**) that delivers recipes based on user-provided ingredients and diet types. It leverages an LLM (Large Language Model) to generate recipe details. At this stage, the service is accessible only on your local environment.

---

## Requirements
- **Ruby 3.2.2**
- **Rails 7.1.5.1**
- A `.env` file with the necessary configuration (based on `.env.sample`)

---

## Installation & Setup

1. **Clone the repository**
   ```bash
   git clone <repository_url>
   cd <repository_folder>

2. **Duplicate the `.env.sample` file**
   ```bash
   cp .env.sample .env
   
For access to API key use your own or please contact the author.\
Currently the needed API key is Groq API key which you can generate here: [Groq API key](https://console.groq.com/keys)
.
3. **Install the dependencies**
   ```bash
   bundle install
   
## Runing service

1. **Start the server**
   ```bash
   rails s
Access the API at `http://localhost:3000`\
The API delivers recipes based on ingredients and diet type via a connection to an external LLM service.

## Project description
The project is a Rails API that connects to an external LLM service to generate recipes based on user-provided ingredients and diet types. 

### Functionality:
1. Receives user input (ingredients, diet type).
2. Communicates with an external Large Language Model to generate recipes.
3. Returns recipe data back to the requesting client.

### Avaialbility
Currently only runs locally; not deployed to production.
For production deployment will be required changes in CORS settings and frontend app endpoints call(currently for POC hard coded).


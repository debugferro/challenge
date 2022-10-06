# Utrust Challenge

Utrust Challenge project for the role of Software Developer.

## 🚀 How to run it?

1. Clone the project `git clone git@github.com:debugferro/challenge.git`
2. Get into the project folder `cd challenge`
3. Create a `.envrc` file in the project's root directory to insert your Etherscan API key as follows:

```
export ETHERSCAN_API_KEY="YOUR ETHERSCAN API KEY"
```

You can run the project's phoenix server with docker or without docker.

##### 🤖 Without docker:

Run the following:

- `source .envrc` to export the env variables,
- `mix deps.get && mix ecto.setup` and
- `mix phx.server` to start the server.

You can access the server at `http://localhost:4000`

##### 🐳 With docker:

Run the following:

- `docker-compose build` and
- `docker-compose up` to start it all.

Now you can access the server at `http://localhost:4000`
Remember to run `docker-compose down` after using it.

## ❓ How to use it?

In order to conduct a transaction, you must first create an account and then insert your tx hash and currency, on the new transaction page. 
The main page shows all of your transactions and you can check the status of every transaction in real-time.

Transactions that are open in the user browser are updated every 2 minutes.

## 💾 Database Diagram

<p align="center">
   <img src="https://i.imgur.com/4iIU7hb.png">
</p>

**Subscription:** this record enables the user to track the progress of a certain transaction.

**Transaction:** is the record that has the transaction data. Visualizing a transaction depends on whether users are subscribed to a particular transaction or not.

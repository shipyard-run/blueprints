package data

import (
	"fmt"
	"log"
	"time"

	"github.com/hashicorp/app/data/model"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

// Connection defines an interface for a Database connection
type Connection interface {
	IsConnected() (bool, error)
	GetProducts() (model.Coffees, error)
	GetIngredientsForCoffee(int) (model.Ingredients, error)
}

// PostgreSQL is the concrete implementation of Conneciton for Postgres
type PostgreSQL struct {
	db *sqlx.DB
}

// New creates a new connection to the database
// if a connection can not be immediately created
func New(connection string, timeout time.Duration) (Connection, error) {
	st := time.Now()

	for {
		if time.Now().Sub(st) > timeout {
			return nil, fmt.Errorf("Timeout connecting to the database")
		}
		db, err := sqlx.Connect("postgres", connection)
		if err == nil {
			return &PostgreSQL{db}, nil
		}

		log.Println("Unable to connect to database", err)
		time.Sleep(5 * time.Second)
	}
}

// IsConnected checks the connection to the database and returns an error if not connected
func (c *PostgreSQL) IsConnected() (bool, error) {
	err := c.db.Ping()
	if err != nil {
		return false, err
	}

	return true, nil
}

// GetProducts returns all products from the database
func (c *PostgreSQL) GetProducts() (model.Coffees, error) {
	cos := model.Coffees{}

	err := c.db.Select(&cos, "SELECT * FROM coffees")
	if err != nil {
		return nil, err
	}

	// fetch the ingredients for each coffee
	for n, cof := range cos {
		i := []model.CoffeeIngredients{}
		err := c.db.Select(&i, "SELECT ingredient_id FROM coffee_ingredients WHERE coffee_id=$1", cof.ID)
		if err != nil {
			return nil, err
		}

		cos[n].Ingredients = i
	}

	return cos, nil
}

// GetIngredientsForCoffee get the ingredients for the given coffeeid
func (c *PostgreSQL) GetIngredientsForCoffee(coffeeid int) (model.Ingredients, error) {
	is := []model.Ingredient{}

	err := c.db.Select(&is,
		`SELECT ingredients.name, coffee_ingredients.quantity, coffee_ingredients.unit FROM ingredients 
		 LEFT JOIN coffee_ingredients ON ingredients.id=coffee_ingredients.ingredient_id 
		 WHERE coffee_ingredients.coffee_id=$1 AND coffee_ingredients.deleted_at IS NULL`,
		coffeeid,
	)
	if err != nil {
		return nil, err
	}

	return is, nil
}

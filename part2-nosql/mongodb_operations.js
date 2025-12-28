// MongoDB Operations for FlexiMart Product Catalog
// Author: [Your Name]
// Student ID: [Your ID]

// Operation 1: Load Data
// Import the provided JSON file into collection 'products'
// Command to run: mongoimport --db fleximart --collection products --file products_catalog.json --jsonArray

use fleximart;

// Operation 2: Basic Query
// Find all products in "Electronics" category with price less than 50000
// Return only: name, price, stock
db.products.find(
    { 
        category: "Electronics", 
        price: { $lt: 50000 } 
    },
    { 
        name: 1, 
        price: 1, 
        stock: 1, 
        _id: 0 
    }
).pretty();

// Operation 3: Review Analysis
// Find all products that have average rating >= 4.0
// Use aggregation to calculate average from reviews array
db.products.aggregate([
    {
        $unwind: "$reviews"  // Flatten the reviews array
    },
    {
        $group: {
            _id: "$_id",
            product_name: { $first: "$name" },
            category: { $first: "$category" },
            avg_rating: { $avg: "$reviews.rating" },
            total_reviews: { $sum: 1 }
        }
    },
    {
        $match: {
            avg_rating: { $gte: 4.0 }
        }
    },
    {
        $project: {
            _id: 0,
            product_name: 1,
            category: 1,
            avg_rating: 1,
            total_reviews: 1
        }
    },
    {
        $sort: { avg_rating: -1 }
    }
]);

// Operation 4: Update Operation
// Add a new review to product "ELEC001"
// Review: {user: "U999", rating: 4, comment: "Good value", date: ISODate()}
db.products.updateOne(
    { product_id: "ELEC001" },
    {
        $push: {
            reviews: {
                user_id: "U999",
                username: "NewCustomer",
                rating: 4,
                comment: "Good value for money!",
                date: new ISODate()
            }
        }
    }
);

// Verify the update
db.products.findOne(
    { product_id: "ELEC001" },
    { name: 1, reviews: { $slice: -1 } }
);

// Operation 5: Complex Aggregation
// Calculate average price by category
// Return: category, avg_price, product_count
// Sort by avg_price descending
db.products.aggregate([
    {
        $group: {
            _id: "$category",
            avg_price: { $avg: "$price" },
            product_count: { $sum: 1 },
            total_stock: { $sum: "$stock" }
        }
    },
    {
        $project: {
            _id: 0,
            category: "$_id",
            avg_price: 1,
            product_count: 1,
            total_stock: 1
        }
    },
    {
        $sort: { avg_price: -1 }
    }
]);

// Bonus Operation: Find products with specific specifications
// Find all smartphones with RAM >= 8GB
db.products.aggregate([
    {
        $match: {
            category: "Electronics",
            subcategory: "Smartphones"
        }
    },
    {
        $addFields: {
            ram_gb: {
                $toInt: {
                    $arrayElemAt: [
                        {
                            $split: [
                                { 
                                    $arrayElemAt: [
                                        { 
                                            $objectToArray: "$specifications" 
                                        }, 
                                        { 
                                            $indexOfArray: [
                                                { 
                                                    $map: {
                                                        input: { $objectToArray: "$specifications" },
                                                        as: "spec",
                                                        in: "$$spec.k"
                                                    }
                                                }, 
                                                "ram"
                                            ] 
                                        }
                                    ] 
                                }.v,
                                "GB"
                            ]
                        },
                        0
                    ]
                }
            }
        }
    },
    {
        $match: {
            ram_gb: { $gte: 8 }
        }
    },
    {
        $project: {
            product_id: 1,
            name: 1,
            price: 1,
            "specifications.ram": 1,
            ram_gb: 1
        }
    }
]);

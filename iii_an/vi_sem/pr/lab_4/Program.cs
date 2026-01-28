using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using System.Text.Json;

namespace MyApplication
{
    class Program
    {
        static readonly HttpClient client = new HttpClient();

        static async Task Main(string[] args)
        {
            
            bool quit = false;

            Console.WriteLine("Welcome to the Category Management System!");
            
            while (!quit)
            {
                Console.WriteLine("Please select an option:");
                Console.WriteLine("1. List categories");
                Console.WriteLine("2. Show category details");
                Console.WriteLine("3. Create new category");
                Console.WriteLine("4. Delete category");
                Console.WriteLine("5. Update category title");
                Console.WriteLine("6. Add product to category");
                Console.WriteLine("7. List products in category");
                Console.WriteLine("8. Quit");

                int option = int.Parse(Console.ReadLine());

                switch (option)
                {
                    case 1:
                        await ListCategories();
                        break;
                    case 2:
                        await ShowCategoryDetails();
                        break;
                    case 3:
                        CreateNewCategory();
                        break;
                    case 4:
                        DeleteCategory();
                        break;
                    case 5:
                        UpdateCategoryTitle();
                        break;
                    case 6:
                        AddProductToCategory();
                        break;
                    case 7:
                        await ListProductsInCategory();
                        break;
                    case 8:
                        quit = true;
                        break;
                    default:
                        Console.WriteLine("Invalid option. Please try again.");
                        break;
                }
            }
        }

         static async Task ListCategories()
        {
            try
            {
                HttpResponseMessage response = await client.GetAsync("http://localhost:5000/api/Category/categories");
                response.EnsureSuccessStatusCode();

                List<CategoryDto> categories = await response.Content.ReadAsAsync<List<CategoryDto>>();

                Console.WriteLine("Categories:");
                foreach (var category in categories)
                {
                    Console.WriteLine($"{category.Id}: {category.Name}");
                }
            }
            catch (HttpRequestException e)
            {
                Console.WriteLine($"Error retrieving categories: {e.Message}");
            }
        }

        static async Task ShowCategoryDetails()
        {
            Console.WriteLine("Please enter the category ID:");
            int categoryId = int.Parse(Console.ReadLine());

            try
            {
                HttpResponseMessage response = await client.GetAsync($"http://localhost:5000/api/Category/categories/{categoryId}");
                response.EnsureSuccessStatusCode();

                List<CategoryDto> categories = await response.Content.ReadAsAsync<List<CategoryDto>>();

                foreach (var category in categories)
                {
                    Console.WriteLine($"Category details for ID {category.Id}:");
                    Console.WriteLine($"Name: {category.Name}");
                    Console.WriteLine($"Items count: {category.ItemsCount}");
                }
            }
            catch (HttpRequestException e)
            {
                Console.WriteLine($"Error retrieving category details: {e.Message}");
            }
        }
        static async Task CreateNewCategory()
        {
            Console.WriteLine("Enter the name of the new category:");
            var title = Console.ReadLine();

            using (var httpClient = new HttpClient())
            {
                var newCategory = new { title };

                var json = JsonSerializer.Serialize(newCategory);

                var content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");

                var response = await httpClient.PostAsync("https://localhost:5001/api/Category/categories", content);

                if (response.IsSuccessStatusCode)
                {
                    Console.WriteLine($"Category '{title}' created successfully.");
                }
                else
                {
                    Console.WriteLine($"Failed to create category '{title}'.");
                }
            }
        }

        static async Task DeleteCategory()
        {
            Console.WriteLine("Enter the ID of the category you want to delete:");
            int id = int.Parse(Console.ReadLine());

            using (var httpClient = new HttpClient())
            {
                var response = await httpClient.DeleteAsync($"https://localhost:5001/api/Category/categories/{id}");

                if (response.IsSuccessStatusCode)
                {
                    Console.WriteLine($"Category with ID '{id}' was deleted successfully.");
                }
                else
                {
                    Console.WriteLine($"Failed to delete category with ID '{id}'.");
                }
            }
        }

        static async Task UpdateCategoryTitle()
        {
            Console.WriteLine("Enter the ID of the category to update:");
            var id = Console.ReadLine();

            Console.WriteLine("Enter the new title:");
            var title = Console.ReadLine();

            using (var httpClient = new HttpClient())
            {
                var newTitle = new { title };

                var json = JsonSerializer.Serialize(newTitle);

                var content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");

                var response = await httpClient.PutAsync($"https://localhost:5001/api/Category/{id}", content);

                if (response.IsSuccessStatusCode)
                {
                    Console.WriteLine($"Category '{id}' title updated to '{title}' successfully.");
                }
                else
                {
                    Console.WriteLine($"Failed to update category '{id}' title to '{title}'.");
                }
            }
        }
        static async void AddProductToCategory()
        {
            Console.WriteLine("Enter the ID of the category:");
            var categoryId = Console.ReadLine();

            Console.WriteLine("Enter the title of the new product:");
            var title = Console.ReadLine();

            Console.WriteLine("Enter the price of the new product:");
            var price = Console.ReadLine();

            var newProduct = new
            {
                id = 0,
                title,
                price,
                categoryId
            };

            using (var httpClient = new HttpClient())
            {
                var json = JsonSerializer.Serialize(newProduct);
                var content = new StringContent(json, System.Text.Encoding.UTF8, "application/json");

                var response = await httpClient.PostAsync($"https://localhost:5001/api/Category/categories/{categoryId}/products", content);

                if (response.IsSuccessStatusCode)
                {
                    Console.WriteLine($"Product '{title}' added to category with ID {categoryId} successfully.");
                }
                else
                {
                    Console.WriteLine($"Failed to add product '{title}' to category with ID {categoryId}.");
                }
            }
        }
        static async Task ListProductsInCategory()
        {
            Console.WriteLine("Enter the ID of the category to list products for:");
            var categoryId = Console.ReadLine();

            using (var httpClient = new HttpClient())
            {
                var response = await httpClient.GetAsync($"https://localhost:5001/api/Category/categories/{categoryId}/products");

                if (response.IsSuccessStatusCode)
                {
                    var products = await response.Content.ReadAsAsync<IEnumerable<ProductDto>>();

                    if (products.Any())
                    {
                        Console.WriteLine($"Products in category {categoryId}:");
                        foreach (var product in products)
                        {
                            Console.WriteLine($"{product.Id} - {product.Title} - {product.Price}");
                        }
                    }
                    else
                    {
                        Console.WriteLine($"No products found in category {categoryId}.");
                    }
                }
                else
                {
                    Console.WriteLine($"Failed to list products for category {categoryId}.");
                }
            }
        }
    }
    public class CategoryDto
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int ItemsCount { get; set; }
    }

    public class ProductDto
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public decimal Price { get; set; }
        public int CategoryId { get; set; }
    }

}

using MediatR;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using UtmShop.DAL;
using UtmShop.Model;

namespace UtmShop.Requests
{
    public class CreateCategoryRequest : IRequest<(bool status, Category cat)>
    {
        public string CategoryTitle { get; set; }

        public CreateCategoryRequest(string categoryTitle)
        {
            CategoryTitle = categoryTitle;
        }

        internal class CreateCategoryRequestHandler : IRequestHandler<CreateCategoryRequest, (bool status, Category cat)>
        {
            private readonly ShopDbContext _context;
            private readonly ILogger<CreateCategoryRequestHandler> _logger;

            public CreateCategoryRequestHandler(ShopDbContext context, ILogger<CreateCategoryRequestHandler> logger)
            {
                _context = context;
                _logger = logger;
            }

            public async Task<(bool status, Category cat)> Handle(CreateCategoryRequest request, CancellationToken cancellationToken)
            {
                try
                {
                    var newCategory = new Category()
                    {
                        Title = request.CategoryTitle
                    };
                    await _context.Categories.AddAsync(newCategory);
                    await _context.SaveChangesAsync();
                    return (true, newCategory);
                }
                catch (Exception ex)
                {
                    _logger.LogError("Unable to create category: {title}. Error: {message}", request.CategoryTitle, ex.Message);
                    return (false, null);
                }
            }
        }
    }
}

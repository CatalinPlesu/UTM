using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using UtmShop.DAL;
using UtmShop.Dto;
using UtmShop.Model;

namespace UtmShop.Requests
{
    public class GetCategoryProductsRequest: IRequest<List<Product>>
    {
        public long CategoryId { get; set; }

        public GetCategoryProductsRequest(long categoryId)
        {
            CategoryId = categoryId;
        }

        internal class GetCategoryProductsRequestHandler : IRequestHandler<GetCategoryProductsRequest, List<Product>>
        {
            private readonly ShopDbContext _context;
            private readonly ILogger<GetCategoryProductsRequestHandler> _logger;

            public GetCategoryProductsRequestHandler(ILogger<GetCategoryProductsRequestHandler> logger, ShopDbContext context)
            {
                _logger = logger ?? throw new ArgumentNullException(nameof(logger));
                _context = context ?? throw new ArgumentNullException(nameof(context));
            }

            public async Task<List<Product>> Handle(GetCategoryProductsRequest request, CancellationToken cancellationToken)
            {
                var category = await _context.Categories
                    .Include(x => x.Products)
                    .FirstOrDefaultAsync(z => z.Id == request.CategoryId, cancellationToken);

                if (category == default)
                    return null;

                return category.Products.ToList();
            }
        }
    }
}

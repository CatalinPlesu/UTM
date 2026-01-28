using MediatR;
using Microsoft.EntityFrameworkCore;
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
    public class GetCategoriesRequest: IRequest<List<Category>>
    {
        public long? SpecificCategory { get; set; }

        public GetCategoriesRequest(long? specificCategory = null)
        {
            SpecificCategory = specificCategory;
        }

        internal class GetGroupsRequestHandler : IRequestHandler<GetCategoriesRequest, List<Category>>
        {
            private readonly ShopDbContext _context;
            private readonly ILogger<GetGroupsRequestHandler> _logger;

            public GetGroupsRequestHandler(ShopDbContext context, ILogger<GetGroupsRequestHandler> logger)
            {
                _context = context ?? throw new ArgumentNullException(nameof(context));
                _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            }

            public Task<List<Category>> Handle(GetCategoriesRequest request, CancellationToken cancellationToken)
            {
                try
                {
                    if (!request.SpecificCategory.HasValue)
                        return Task.FromResult(_context.Categories.Include(x=>x.Products).ToList());
                    return Task.FromResult(_context.Categories.Include(x => x.Products).Where(category => category.Id == request.SpecificCategory).ToList());
                }
                catch(Exception ex)
                {
                    _logger.LogError(">>> Error reading db. {message}", ex.Message);
                }
                return null;
            }
        }
    }
}

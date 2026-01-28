using MediatR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using UtmShop.DAL;
using Microsoft.EntityFrameworkCore;

namespace UtmShop.Requests
{
    public class FindCategoryRequest : IRequest<long?>
    {
        public string CategoryTitle { get; set; }

        public FindCategoryRequest(string categoryTitle)
        {
            CategoryTitle = categoryTitle;
        }
        internal class FindCategoryRequestHandler : IRequestHandler<FindCategoryRequest, long?>
        {
            private readonly ShopDbContext _context;

            public FindCategoryRequestHandler(ShopDbContext context)
            {
                _context = context ?? throw new ArgumentNullException(nameof(context));
            }

            public async Task<long?> Handle(FindCategoryRequest request, CancellationToken cancellationToken)
            {
                var reqResult = await _context.Categories.FirstOrDefaultAsync(x => x.Title == request.CategoryTitle, cancellationToken);
                if (reqResult != default)
                    return reqResult.Id;
                return null;
            }
        }
    }
}

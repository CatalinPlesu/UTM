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
    public class ChangeCategoryTitleRequest : IRequest<Category>
    {
        public long CategoryId { get; set; }
        public string EditedTitle { get; set; }

        public ChangeCategoryTitleRequest(long categoryId, string editedTitle)
        {
            CategoryId = categoryId;
            EditedTitle = editedTitle;
        }

        internal class ChangeCategoryTitleRequestHandler : IRequestHandler<ChangeCategoryTitleRequest, Category>
        {
            private readonly ShopDbContext _context;
            private readonly ILogger<ChangeCategoryTitleRequestHandler> _logger;

            public ChangeCategoryTitleRequestHandler(ILogger<ChangeCategoryTitleRequestHandler> logger, ShopDbContext context)
            {
                _logger = logger;
                _context = context;
            }

            public async Task<Category> Handle(ChangeCategoryTitleRequest request, CancellationToken cancellationToken)
            {
                var category = await _context.Categories.FirstOrDefaultAsync(x => x.Id == request.CategoryId, cancellationToken);
                if (category == default)
                    return null;
                category.Title = request.EditedTitle;
                try
                {
                    await _context.SaveChangesAsync(cancellationToken);
                }
                catch(Exception ex)
                {
                    _logger.LogError("Error saving in db. {Message}", ex.Message);
                    return null;
                }
                category = await _context.Categories.Include(x => x.Products).FirstOrDefaultAsync(x => x.Id == category.Id);
                return category;
            }
        }
    }
}

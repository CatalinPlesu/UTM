using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using UtmShop.DAL;

namespace UtmShop.Requests
{
    public class DeleteCategoryRequest : IRequest<bool>
    {
        public long CategoryId { get; set; }

        public DeleteCategoryRequest(long categoryId)
        {
            CategoryId = categoryId;
        }

        internal class DeleteCategoryRequestHandler : IRequestHandler<DeleteCategoryRequest, bool>
        {
            private readonly ShopDbContext _context;
            private readonly ILogger<DeleteCategoryRequestHandler> _logger;

            public DeleteCategoryRequestHandler(ShopDbContext context, ILogger<DeleteCategoryRequestHandler> logger)
            {
                _context = context ?? throw new ArgumentNullException(nameof(context));
                _logger = logger ?? throw new ArgumentNullException(nameof(logger));
            }

            public async Task<bool> Handle(DeleteCategoryRequest request, CancellationToken cancellationToken)
            {
                var requiredCategory = await _context.Categories.FirstOrDefaultAsync(x => x.Id == request.CategoryId);
                if (requiredCategory == null)
                    return false;
                _context.Categories.Remove(requiredCategory);
                try
                {
                    await _context.SaveChangesAsync();
                    return true;
                }
                catch (Exception ex)
                {
                    _logger.LogError("Error deleting data: {message}", ex.Message);
                }
                return false;
            }
        }
    }
}

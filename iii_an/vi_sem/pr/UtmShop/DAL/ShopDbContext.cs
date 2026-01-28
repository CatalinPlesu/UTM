using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using UtmShop.Model;

namespace UtmShop.DAL
{
    public class ShopDbContext : DbContext
    {
        public DbSet<Category> Categories { get; set; }
        public DbSet<Product> Products { get; set; }
        public ShopDbContext(DbContextOptions<ShopDbContext> options) : base(options)
        {

        }
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            modelBuilder.Entity<Category>()
                .HasKey(x => x.Id);
            modelBuilder.Entity<Product>()
                .HasKey(x => x.Id);
            modelBuilder.Entity<Category>()
                .HasMany(x => x.Products)
                .WithOne(z => z.ParentCategory)
                .OnDelete(DeleteBehavior.Cascade);
            modelBuilder.Entity<Product>().HasOne(x => x.ParentCategory).WithMany(x => x.Products).IsRequired();
        }
    }
}

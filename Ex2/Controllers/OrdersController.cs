using System.Data.SqlTypes;
using Ex2.Data;
using Ex2.Dtos;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace Ex2.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OrdersController : ControllerBase
    {
        private readonly ApplicationDbContext _context;
        public OrdersController(ApplicationDbContext context)
        {
            _context = context;
        }

        [HttpGet("report")]
        public async Task<IActionResult> GetOrderReport([FromQuery] OrderRequest request)
        {
            var parameters = new[]
                {
                    new SqlParameter("@StartDate", request.StartDate.HasValue && request.StartDate.Value > SqlDateTime.MinValue.Value
                    ? request.StartDate.Value
                    : DBNull.Value ),
                    new SqlParameter("@EndDate", request.EndDate.HasValue && request.EndDate.Value > SqlDateTime.MinValue.Value
                    ? request.EndDate.Value
                    : DBNull.Value ),
                    new SqlParameter("@CustomerID", request.CustomerId ?? (object)DBNull.Value),
                    new SqlParameter("@MinAmount", request.MinAmount ?? (object)DBNull.Value),
                    new SqlParameter("@MaxAmount", request.MaxAmount ?? (object)DBNull.Value),
                    new SqlParameter("@OrderStatus", request.OrderStatus ?? (object)DBNull.Value),
                    new SqlParameter("@ShipmentStatus", request.ShipmentStatus ?? (object)DBNull.Value)
                };

            var results = await _context.Database
            .SqlQueryRaw<OrderResponse>(
                "EXEC sp_GetComplexOrderReport @StartDate, @EndDate, @CustomerID, @MinAmount, @MaxAmount, @OrderStatus, @ShipmentStatus",
                parameters).ToListAsync();

            return Ok(results);
        }
    }
}

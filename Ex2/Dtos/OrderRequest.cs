namespace Ex2.Dtos
{
    public class OrderRequest
    {
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? CustomerId { get; set; }
        public decimal? MinAmount { get; set; }
        public decimal? MaxAmount { get; set; }
        public string? OrderStatus { get; set; }
        public string? ShipmentStatus { get; set; }
    }
}

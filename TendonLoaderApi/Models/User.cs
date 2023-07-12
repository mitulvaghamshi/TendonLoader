using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TendonLoaderApi.Models;

[Table("User")]
public partial class User
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Required]
    [Column("username")]
    [StringLength(100)]
    public string Username { get; set; } = default!;

    [Required]
    [Column("password")]
    public string Password { get; set; } = default!;

    [InverseProperty("User")]
    public virtual Settings Settings { get; set; } = null!;

    [InverseProperty("User")]
    public virtual ICollection<Exercise> Exercises { get; set; } = new List<Exercise>();
}

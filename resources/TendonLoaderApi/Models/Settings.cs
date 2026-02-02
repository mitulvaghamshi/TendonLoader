using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TendonLoaderApi.Models;

[Table("Settings")]
public class Settings
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Required]
    [Column("user_id")]
    public int UserId { get; set; }

    [Column("prescription_id")]
    public int? PrescriptionId { get; set; }

    [Required]
    [Column("dark_mode")]
    public bool DarkMode { get; set; }

    [Required]
    [Column("auto_upload")]
    public bool AutoUpload { get; set; }

    [Required]
    [Column("editable_prescription")]
    public bool EditablePrescriprion { get; set; }

    [Required]
    [Column("graph_scale")]
    public double GraphScale { get; set; }

    //[ForeignKey(nameof(UserId))]
    //[InverseProperty("Settings")]
    //public virtual User User { get; set; } = null!;

    //[ForeignKey(nameof(PrescriptionId))]
    //[InverseProperty("Settings")]
    //public virtual Prescription? Prescription { get; set; }
}

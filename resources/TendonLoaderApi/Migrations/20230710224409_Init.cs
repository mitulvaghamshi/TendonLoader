using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TendonLoaderApi.Migrations;

/// <inheritdoc />
public partial class Init : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "Prescription",
            columns: table => new
            {
                id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                reps = table.Column<int>(type: "INTEGER", nullable: false),
                sets = table.Column<int>(type: "INTEGER", nullable: false),
                set_rest = table.Column<int>(type: "INTEGER", nullable: false),
                hold_time = table.Column<int>(type: "INTEGER", nullable: false),
                rest_time = table.Column<int>(type: "INTEGER", nullable: false),
                mvc_duration = table.Column<int>(type: "INTEGER", nullable: false),
                target_load = table.Column<double>(type: "REAL", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Prescription", x => x.id);
            });

        migrationBuilder.CreateTable(
            name: "User",
            columns: table => new
            {
                id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                username = table.Column<string>(type: "TEXT", maxLength: 100, nullable: false),
                password = table.Column<string>(type: "TEXT", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_User", x => x.id);
            });

        migrationBuilder.CreateTable(
            name: "Exercise",
            columns: table => new
            {
                id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                user_id = table.Column<int>(type: "INTEGER", nullable: false),
                prescription_id = table.Column<int>(type: "INTEGER", nullable: true),
                pain_score = table.Column<double>(type: "REAL", nullable: false),
                datetime = table.Column<string>(type: "TEXT", maxLength: 50, nullable: false),
                tolerable = table.Column<string>(type: "TEXT", maxLength: 10, nullable: false),
                completed = table.Column<bool>(type: "INTEGER", nullable: false),
                progressor_id = table.Column<string>(type: "TEXT", maxLength: 30, nullable: false),
                mvc_value = table.Column<double>(type: "REAL", nullable: true),
                data = table.Column<string>(type: "TEXT", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Exercise", x => x.id);
                table.ForeignKey(
                    name: "FK_Exercise_Prescription_prescription_id",
                    column: x => x.prescription_id,
                    principalTable: "Prescription",
                    principalColumn: "id");
                table.ForeignKey(
                    name: "FK_Exercise_User_user_id",
                    column: x => x.user_id,
                    principalTable: "User",
                    principalColumn: "id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "Settings",
            columns: table => new
            {
                id = table.Column<int>(type: "INTEGER", nullable: false)
                    .Annotation("Sqlite:Autoincrement", true),
                user_id = table.Column<int>(type: "INTEGER", nullable: false),
                prescription_id = table.Column<int>(type: "INTEGER", nullable: true),
                dark_mode = table.Column<bool>(type: "INTEGER", nullable: false),
                auto_upload = table.Column<bool>(type: "INTEGER", nullable: false),
                editable_prescription = table.Column<bool>(type: "INTEGER", nullable: false),
                graph_scale = table.Column<double>(type: "REAL", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_Settings", x => x.id);
                table.ForeignKey(
                    name: "FK_Settings_Prescription_prescription_id",
                    column: x => x.prescription_id,
                    principalTable: "Prescription",
                    principalColumn: "id");
                table.ForeignKey(
                    name: "FK_Settings_User_user_id",
                    column: x => x.user_id,
                    principalTable: "User",
                    principalColumn: "id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateIndex(
            name: "IX_Exercise_prescription_id",
            table: "Exercise",
            column: "prescription_id",
            unique: true);

        migrationBuilder.CreateIndex(
            name: "IX_Exercise_user_id",
            table: "Exercise",
            column: "user_id");

        migrationBuilder.CreateIndex(
            name: "IX_Settings_prescription_id",
            table: "Settings",
            column: "prescription_id",
            unique: true);

        migrationBuilder.CreateIndex(
            name: "IX_Settings_user_id",
            table: "Settings",
            column: "user_id",
            unique: true);
    }

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(
            name: "Exercise");

        migrationBuilder.DropTable(
            name: "Settings");

        migrationBuilder.DropTable(
            name: "Prescription");

        migrationBuilder.DropTable(
            name: "User");
    }
}

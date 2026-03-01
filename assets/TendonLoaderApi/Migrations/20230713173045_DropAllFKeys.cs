using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace TendonLoaderApi.Migrations;

/// <inheritdoc />
public partial class DropAllFKeys : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropForeignKey(
            name: "FK_Exercise_Prescription_prescription_id",
            table: "Exercise");

        migrationBuilder.DropForeignKey(
            name: "FK_Exercise_User_user_id",
            table: "Exercise");

        migrationBuilder.DropForeignKey(
            name: "FK_Settings_Prescription_prescription_id",
            table: "Settings");

        migrationBuilder.DropForeignKey(
            name: "FK_Settings_User_user_id",
            table: "Settings");

        migrationBuilder.DropIndex(
            name: "IX_Settings_prescription_id",
            table: "Settings");

        migrationBuilder.DropIndex(
            name: "IX_Settings_user_id",
            table: "Settings");

        migrationBuilder.DropIndex(
            name: "IX_Exercise_prescription_id",
            table: "Exercise");

        migrationBuilder.DropIndex(
            name: "IX_Exercise_user_id",
            table: "Exercise");
    }

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
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

        migrationBuilder.CreateIndex(
            name: "IX_Exercise_prescription_id",
            table: "Exercise",
            column: "prescription_id",
            unique: true);

        migrationBuilder.CreateIndex(
            name: "IX_Exercise_user_id",
            table: "Exercise",
            column: "user_id");

        migrationBuilder.AddForeignKey(
            name: "FK_Exercise_Prescription_prescription_id",
            table: "Exercise",
            column: "prescription_id",
            principalTable: "Prescription",
            principalColumn: "id");

        migrationBuilder.AddForeignKey(
            name: "FK_Exercise_User_user_id",
            table: "Exercise",
            column: "user_id",
            principalTable: "User",
            principalColumn: "id",
            onDelete: ReferentialAction.Cascade);

        migrationBuilder.AddForeignKey(
            name: "FK_Settings_Prescription_prescription_id",
            table: "Settings",
            column: "prescription_id",
            principalTable: "Prescription",
            principalColumn: "id");

        migrationBuilder.AddForeignKey(
            name: "FK_Settings_User_user_id",
            table: "Settings",
            column: "user_id",
            principalTable: "User",
            principalColumn: "id",
            onDelete: ReferentialAction.Cascade);
    }
}

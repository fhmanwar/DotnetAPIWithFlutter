using Microsoft.EntityFrameworkCore.Migrations;

namespace API.Migrations
{
    public partial class UpdateProductAndCategoryModel : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Tbl_Product_Tbl_CategoryProduct_ProductCategory",
                table: "Tbl_Product");

            migrationBuilder.RenameColumn(
                name: "ProductCategory",
                table: "Tbl_Product",
                newName: "CategoryId");

            migrationBuilder.RenameIndex(
                name: "IX_Tbl_Product_ProductCategory",
                table: "Tbl_Product",
                newName: "IX_Tbl_Product_CategoryId");

            migrationBuilder.AddForeignKey(
                name: "FK_Tbl_Product_Tbl_CategoryProduct_CategoryId",
                table: "Tbl_Product",
                column: "CategoryId",
                principalTable: "Tbl_CategoryProduct",
                principalColumn: "CategoryId",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Tbl_Product_Tbl_CategoryProduct_CategoryId",
                table: "Tbl_Product");

            migrationBuilder.RenameColumn(
                name: "CategoryId",
                table: "Tbl_Product",
                newName: "ProductCategory");

            migrationBuilder.RenameIndex(
                name: "IX_Tbl_Product_CategoryId",
                table: "Tbl_Product",
                newName: "IX_Tbl_Product_ProductCategory");

            migrationBuilder.AddForeignKey(
                name: "FK_Tbl_Product_Tbl_CategoryProduct_ProductCategory",
                table: "Tbl_Product",
                column: "ProductCategory",
                principalTable: "Tbl_CategoryProduct",
                principalColumn: "CategoryId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}

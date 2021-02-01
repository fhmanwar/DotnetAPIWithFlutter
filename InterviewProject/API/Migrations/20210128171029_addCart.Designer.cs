﻿// <auto-generated />
using System;
using API.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace API.Migrations
{
    [DbContext(typeof(MyContext))]
    [Migration("20210128171029_addCart")]
    partial class addCart
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "2.1.14-servicing-32113")
                .HasAnnotation("Relational:MaxIdentifierLength", 128)
                .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

            modelBuilder.Entity("API.Models.Cart", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<int>("ProductId");

                    b.Property<int>("Quantity");

                    b.Property<int>("SubTotal");

                    b.Property<int>("UserId");

                    b.HasKey("Id");

                    b.HasIndex("ProductId");

                    b.HasIndex("UserId");

                    b.ToTable("Tbl_Cart");
                });

            modelBuilder.Entity("API.Models.Product", b =>
                {
                    b.Property<int>("ProductId")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<int>("CategoryId");

                    b.Property<int>("Price");

                    b.Property<string>("ProductName");

                    b.Property<int>("Stock");

                    b.Property<string>("Unit");

                    b.HasKey("ProductId");

                    b.HasIndex("CategoryId");

                    b.ToTable("Tbl_Product");
                });

            modelBuilder.Entity("API.Models.ProductCategory", b =>
                {
                    b.Property<int>("CategoryId")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<string>("CategoryName");

                    b.HasKey("CategoryId");

                    b.ToTable("Tbl_CategoryProduct");
                });

            modelBuilder.Entity("API.Models.Role", b =>
                {
                    b.Property<int>("RoleId")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<DateTimeOffset>("CreateDate");

                    b.Property<DateTimeOffset>("DeleteDate");

                    b.Property<string>("RoleName");

                    b.Property<DateTimeOffset>("UpdateDate");

                    b.Property<bool>("isDelete");

                    b.HasKey("RoleId");

                    b.ToTable("TB_M_Role");
                });

            modelBuilder.Entity("API.Models.Transaction", b =>
                {
                    b.Property<int>("TransactionId")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<DateTimeOffset>("OrderDate");

                    b.Property<int>("Total");

                    b.Property<int>("UserId");

                    b.HasKey("TransactionId");

                    b.HasIndex("UserId");

                    b.ToTable("Tbl_Transaction");
                });

            modelBuilder.Entity("API.Models.TransactionItem", b =>
                {
                    b.Property<int>("TransactionItemId")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<int>("ProductId");

                    b.Property<int>("Quantity");

                    b.Property<int>("SubTotal");

                    b.Property<int>("TransactionId");

                    b.HasKey("TransactionItemId");

                    b.HasIndex("ProductId");

                    b.HasIndex("TransactionId");

                    b.ToTable("Tbl_TransactionItem");
                });

            modelBuilder.Entity("API.Models.User", b =>
                {
                    b.Property<int>("Id")
                        .ValueGeneratedOnAdd()
                        .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

                    b.Property<DateTimeOffset>("CreateDate");

                    b.Property<DateTimeOffset>("DeleteDate");

                    b.Property<string>("Email");

                    b.Property<string>("Name");

                    b.Property<string>("Password");

                    b.Property<int>("RoleId");

                    b.Property<string>("Token");

                    b.Property<DateTimeOffset>("UpdateDate");

                    b.Property<string>("VerifyCode");

                    b.Property<bool>("isDelete");

                    b.HasKey("Id");

                    b.HasIndex("RoleId");

                    b.ToTable("TB_M_User");
                });

            modelBuilder.Entity("API.Models.Cart", b =>
                {
                    b.HasOne("API.Models.Product", "Product")
                        .WithMany()
                        .HasForeignKey("ProductId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.HasOne("API.Models.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade);
                });

            modelBuilder.Entity("API.Models.Product", b =>
                {
                    b.HasOne("API.Models.ProductCategory", "Category")
                        .WithMany()
                        .HasForeignKey("CategoryId")
                        .OnDelete(DeleteBehavior.Cascade);
                });

            modelBuilder.Entity("API.Models.Transaction", b =>
                {
                    b.HasOne("API.Models.User", "User")
                        .WithMany()
                        .HasForeignKey("UserId")
                        .OnDelete(DeleteBehavior.Cascade);
                });

            modelBuilder.Entity("API.Models.TransactionItem", b =>
                {
                    b.HasOne("API.Models.Product", "Product")
                        .WithMany()
                        .HasForeignKey("ProductId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.HasOne("API.Models.Transaction", "Transaction")
                        .WithMany()
                        .HasForeignKey("TransactionId")
                        .OnDelete(DeleteBehavior.Cascade);
                });

            modelBuilder.Entity("API.Models.User", b =>
                {
                    b.HasOne("API.Models.Role", "Role")
                        .WithMany()
                        .HasForeignKey("RoleId")
                        .OnDelete(DeleteBehavior.Cascade);
                });
#pragma warning restore 612, 618
        }
    }
}
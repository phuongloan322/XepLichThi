USE [master]
GO
/****** Object:  Database [XepLichThi]    Script Date: 17/05/2021 8:59:01 PM ******/
CREATE DATABASE [XepLichThi]
 CONTAINMENT = NONE
GO
ALTER DATABASE [XepLichThi] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [XepLichThi].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [XepLichThi] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [XepLichThi] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [XepLichThi] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [XepLichThi] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [XepLichThi] SET ARITHABORT OFF 
GO
ALTER DATABASE [XepLichThi] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [XepLichThi] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [XepLichThi] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [XepLichThi] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [XepLichThi] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [XepLichThi] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [XepLichThi] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [XepLichThi] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [XepLichThi] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [XepLichThi] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [XepLichThi] SET  DISABLE_BROKER 
GO
ALTER DATABASE [XepLichThi] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [XepLichThi] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [XepLichThi] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [XepLichThi] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [XepLichThi] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [XepLichThi] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [XepLichThi] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [XepLichThi] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [XepLichThi] SET  MULTI_USER 
GO
ALTER DATABASE [XepLichThi] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [XepLichThi] SET DB_CHAINING OFF 
GO
ALTER DATABASE [XepLichThi] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [XepLichThi] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [XepLichThi]
GO
/****** Object:  StoredProcedure [dbo].[proc_DK_Sua]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_DK_Sua] (
	@MaDieuKien nvarchar(50)
	,@TenDieuKien nvarchar(50)
	,@SoBuoiNghi int
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaDieuKien IS NULL OR @MaDieuKien = '' OR
		@TenDieuKien IS NULL OR @TenDieuKien = '' OR
		@SoBuoiNghi IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM DieuKien WHERE MaDieuKien = @MaDieuKien))
	BEGIN
		SET @Result = -2
		RETURN
	END

	UPDATE DieuKien
	SET	TenDieuKien = @TenDieuKien
		,SoBuoiNghi = @SoBuoiNghi
	WHERE MaDieuKien = @MaDieuKien
	SET @Result = 0
END



GO
/****** Object:  StoredProcedure [dbo].[proc_DK_Them]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_DK_Them] (
	@MaDieuKien nvarchar(50)
	,@TenDieuKien nvarchar(50)
	,@SoBuoiNghi int
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaDieuKien IS NULL OR @MaDieuKien = '' OR
		@TenDieuKien IS NULL OR @TenDieuKien = '' OR
		@SoBuoiNghi IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT * FROM DieuKien WHERE MaDieuKien = @MaDieuKien)
	BEGIN
		SET @Result = -2
		RETURN
	END

	INSERT INTO DieuKien (MaDieuKien, TenDieuKien, SoBuoiNghi) VALUES (@MaDieuKien, @TenDieuKien, @SoBuoiNghi)
	SET @Result = 0
	RETURN
END

GO
/****** Object:  StoredProcedure [dbo].[proc_DK_Xoa]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_DK_Xoa] (
	@MaDieuKien nvarchar(50)
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaDieuKien IS NULL OR @MaDieuKien = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM DieuKien WHERE MaDieuKien = @MaDieuKien))
	BEGIN
		SET @Result = -2
		RETURN
	END

	DELETE FROM DieuKien
	WHERE MaDieuKien = @MaDieuKien
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_DSSV_LHP_Sua]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_DSSV_LHP_Sua] (
	@MaSinhVien nvarchar(50)
	,@MaLopHocPhan nvarchar(50)
	,@LanHoc int
	,@ThuocKHDT bit
	,@Result int
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaSinhVien IS NULL OR @MaSinhVien = '' OR
		@MaLopHocPhan IS NULL OR @MaLopHocPhan = '' OR
		@LanHoc IS NULL OR
		@ThuocKHDT IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT *
					FROM DanhSachSVLopHP 
					WHERE MaSinhVien = @MaSinhVien AND 
						MaLopHocPhan = @MaLopHocPhan AND
						LanHoc = @LanHoc))
	BEGIN
		SET @Result = -2
		RETURN
	END

	UPDATE DanhSachSVLopHP
	SET	ThuocKHDT = @ThuocKHDT
	WHERE MaSinhVien = @MaSinhVien AND
		MaLopHocPhan = @MaLopHocPhan AND
		LanHoc = @LanHoc
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_DSSV_LHP_Them]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_DSSV_LHP_Them] (
	@MaSinhVien nvarchar(50)
	,@MaLopHocPhan nvarchar(50)
	,@LanHoc int
	,@ThuocKHDT bit
	,@Result int
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaSinhVien IS NULL OR @MaSinhVien = '' OR
		@MaLopHocPhan IS NULL OR @MaLopHocPhan = '' OR
		@LanHoc IS NULL OR
		@ThuocKHDT IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM SinhVien WHERE MaSinhVien = @MaSinhVien))
	BEGIN
		SET @Result = -2
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM LopHocPhan WHERE MaLopHocPhan = @MaLopHocPhan))
	BEGIN
		SET @Result = -3
		RETURN
	END

	IF EXISTS(SELECT * 
				FROM DanhSachSVLopHP 
				WHERE MaSinhVien = @MaSinhVien AND
					MaLopHocPhan = @MaLopHocPhan AND
					LanHoc = @LanHoc)
	BEGIN
		SET @Result = -4
		RETURN
	END

	INSERT INTO DanhSachSVLopHP (MaSinhVien, MaLopHocPhan, LanHoc, ThuocKHDT)
	VALUES (@MaSinhVien, @MaLopHocPhan, @LanHoc, @ThuocKHDT)
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_DSSV_LHP_Xoa]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_DSSV_LHP_Xoa] (
	@MaSinhVien nvarchar(50)
	,@MaLopHocPhan nvarchar(50)
	,@LanHoc int
	,@Result int
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaSinhVien IS NULL OR @MaSinhVien = '' OR
		@MaLopHocPhan IS NULL OR @MaLopHocPhan = '' OR
		@LanHoc IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT *
					FROM DanhSachSVLopHP
					WHERE	MaSinhVien = @MaSinhVien
						AND MaLopHocPhan = @MaLopHocPhan
						AND	LanHoc = @LanHoc))
	BEGIN
		SET @Result = -2
		RETURN
	END

	DELETE DanhSachSVLopHP
	WHERE	MaSinhVien = @MaSinhVien
		AND MaLopHocPhan = @MaLopHocPhan
		AND LanHoc = @LanHoc
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_Lich_Thi_Sua]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_Lich_Thi_Sua] (
	@MaLichThi nvarchar(50)
	,@NgayThi datetime
	,@Thoigian int
	,@Result int
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaLichThi IS NULL OR @MaLichThi = '' OR
		@NgayThi IS NULL OR
		@Thoigian IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM LichThi WHERE MaLichThi = @MaLichThi))
	BEGIN
		SET @Result = -2
		RETURN
	END

	UPDATE	LichThi
	SET		NgayThi = @NgayThi
			,ThoiGian = @Thoigian
	WHERE	MaLichThi = @MaLichThi
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_Lich_Thi_Them]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_Lich_Thi_Them] (
	@MaLichThi nvarchar(50)
	,@MaLopHocPhan nvarchar(50)
	,@NgayThi datetime
	,@Thoigian int
	,@MaPhongThi nvarchar(50)
	,@HinhThuc nvarchar(50)
	,@Result int
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaLichThi IS NULL OR @MaLichThi = '' OR
		@MaLopHocPhan IS NULL OR @MaLichThi = '' OR
		@NgayThi IS NULL OR
		@Thoigian IS NULL OR
		@MaPhongThi IS NULL OR @MaPhongThi = '' OR
		@HinhThuc IS NULL OR @HinhThuc = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT * FROM LichThi WHERE MaLichThi = @MaLichThi)
	BEGIN
		SET @Result = -2
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM LopHocPhan WHERE MaLopHocPhan = @MaLopHocPhan))
	BEGIN
		SET @Result = -3
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM PhongThi WHERE MaPhongThi = @MaPhongThi))
	BEGIN
		SET @Result = -4
		RETURN
	END
	
	IF NOT(@HinhThuc IN ('LT','TH','VD'))
	BEGIN
		SET @Result = -5
		RETURN
	END

	DECLARE @LoaiPhongThi nvarchar(50)
	SELECT	@LoaiPhongThi = LoaiPhongThi
	FROM	PhongThi AS PT
		JOIN LoaiPhongThi AS LPT ON PT.MaLoaiPhongThi = LPT.MaLoaiPhongThi
	WHERE	MaPhongThi = @MaPhongThi
	IF CHARINDEX(@HinhThuc, @LoaiPhongThi) = 0
	BEGIN
		SET @Result = -6
		RETURN
	END

	IF EXISTS(SELECT	*
				FROM	LichThi
				WHERE	MaLichThi = @MaLichThi
					AND	MaLopHocPhan = @MaLopHocPhan
					AND MaPhongThi = @MaPhongThi
					AND ThoiGian = @Thoigian
			)
	BEGIN
		SET @Result = -7
		RETURN
	END

	INSERT INTO LichThi (MaLichThi, MaLopHocPhan, NgayThi, ThoiGian, MaPhongThi, HinhThuc)
	VALUES (@MaLichThi, @MaLopHocPhan, @NgayThi, @Thoigian, @MaPhongThi, @HinhThuc)
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_Lich_Thi_Xoa]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_Lich_Thi_Xoa] (
	@MaLichThi nvarchar(50)
	,@Result int	
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaLichThi IS NULL OR @MaLichThi = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM LichThi WHERE MaLichThi = @MaLichThi))
	BEGIN
		SET @Result = -2
		RETURN
	END

	DELETE FROM	LichThi
	WHERE		MaLichThi = @MaLichThi
	SET			@Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_LopHP_Sua]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_LopHP_Sua] (
	@MaLopHocPhan nvarchar(50)
	,@TenLopHocPhan nvarchar(50)
	,@SoTinChi int
	,@HinhThucThi nvarchar(50)
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaLopHocPhan IS NULL OR @MaLopHocPhan = '' OR
		@TenLopHocPhan IS NULL OR @TenLopHocPhan = '' OR 
		@SoTinChi IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM LopHocPhan WHERE MaLopHocPhan = @MaLopHocPhan))
	BEGIN
		SET @Result = -2
		RETURN
	END

	UPDATE LopHocPhan
	SET	TenLopHocPhan = @TenLopHocPhan
		,SoTinChi = @SoTinChi
		,HinhThucThi = @HinhThucThi
	WHERE MaLopHocPhan = @MaLopHocPhan
	SET @Result = 0 
END

GO
/****** Object:  StoredProcedure [dbo].[proc_LopHP_Them]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_LopHP_Them] (
	@MaLopHocPhan nvarchar(50)
	,@TenLopHocPhan nvarchar(50)
	,@SoTinChi int
	,@HinhThucThi nvarchar(50)
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaLopHocPhan IS NULL OR @MaLopHocPhan = '' OR
		@TenLopHocPhan IS NULL OR @TenLopHocPhan = '' OR 
		@HinhThucThi IS NULL OR @HinhThucThi = '' OR
		@SoTinChi IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT * FROM LopHocPhan WHERE MaLopHocPhan = @MaLopHocPhan)
	BEGIN
		SET @Result = -2
		RETURN
	END

	INSERT LopHocPhan (MaLopHocPhan, TenLopHocPhan, SoTinChi, HinhThucThi) VALUES (@MaLopHocPhan, @TenLopHocPhan, @SoTinChi, @HinhThucThi)
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_LopHP_Xoa]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_LopHP_Xoa] (
	@MaLopHocPhan nvarchar(50)
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaLopHocPhan IS NULL OR @MaLopHocPhan = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM LopHocPhan WHERE MaLopHocPhan = @MaLopHocPhan))
	BEGIN
		SET @Result = -2
		RETURN
	END

	DELETE FROM	DanhSachSVLopHP
	WHERE	MaLopHocPhan = @MaLopHocPhan

	DELETE FROM LopHocPhan
	WHERE MaLopHocPhan = @MaLopHocPhan
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_LPT_Sua]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_LPT_Sua] (
	@MaLoaiPhongThi nvarchar(50)
	,@LoaiPhongThi nvarchar(50)
	,@ChiTiet nvarchar(50)
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaLoaiPhongThi IS NULL OR @MaLoaiPhongThi = '' OR
		@MaLoaiPhongThi IS NULL OR @MaLoaiPhongThi = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM LoaiPhongThi WHERE MaLoaiPhongThi = @MaLoaiPhongThi))
	BEGIN
		SET @Result = -2
		RETURN
	END

	UPDATE LoaiPhongThi
	SET	LoaiPhongThi = @LoaiPhongThi
		,ChiTiet = @ChiTiet
	WHERE MaLoaiPhongThi = @MaLoaiPhongThi
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_LPT_Them]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_LPT_Them] (
	@MaLoaiPhongThi nvarchar(50)
	,@LoaiPhongThi nvarchar(50)
	,@ChiTiet nvarchar(50)
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaLoaiPhongThi IS NULL OR @MaLoaiPhongThi = '' OR
		@LoaiPhongThi IS NULL OR @LoaiPhongThi = '' 
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT * FROM LoaiPhongThi WHERE MaLoaiPhongThi = @MaLoaiPhongThi)
	BEGIN
		SET @Result = -2
		RETURN
	END

	INSERT INTO LoaiPhongThi(MaLoaiPhongThi,LoaiPhongThi,ChiTiet) VALUES (@MaLoaiPhongThi, @LoaiPhongThi, @ChiTiet)
	SET @Result = 0
	RETURN
END

GO
/****** Object:  StoredProcedure [dbo].[proc_LPT_Xoa]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_LPT_Xoa] (
	@MaLoaiPhongThi nvarchar(50)
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaLoaiPhongThi IS NULL OR @MaLoaiPhongThi = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM LoaiPhongThi WHERE MaLoaiPhongThi = @MaLoaiPhongThi))
	BEGIN
		SET @Result = -2
		RETURN
	END

	DELETE FROM LoaiPhongThi
	WHERE MaLoaiPhongThi = @MaLoaiPhongThi
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_PT_Sua]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_PT_Sua] (
	@MaPhongThi nvarchar(50)
	,@MaLoaiPhongThi nvarchar(50)
	,@SoChoNgoi int
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaPhongThi IS NULL OR @MaPhongThi = '' OR
		@MaLoaiPhongThi IS NULL OR @MaLoaiPhongThi = '' OR
		@SoChoNgoi IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM PhongThi WHERE MaPhongThi = @MaPhongThi))
	BEGIN
		SET @Result = -2
		RETURN
	END

	UPDATE PhongThi
	SET	MaLoaiPhongThi = @MaLoaiPhongThi
		,SoChoNgoi = @SoChoNgoi
	WHERE MaPhongThi = @MaPhongThi
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_PT_Them]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_PT_Them] (
	@MaPhongThi nvarchar(50)
	,@MaLoaiPhongThi nvarchar(50)
	,@SoChoNgoi int
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaPhongThi IS NULL OR @MaPhongThi = '' OR
		@MaLoaiPhongThi IS NULL OR @MaLoaiPhongThi = '' OR
		@SoChoNgoi IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT * FROM PhongThi WHERE MaPhongThi = @MaPhongThi)
	BEGIN
		SET @Result = -2
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM LoaiPhongThi WHERE MaLoaiPhongThi = @MaLoaiPhongThi))
	BEGIN
		SET @Result = -3
		RETURN
	END

	INSERT INTO PhongThi(MaPhongThi,MaLoaiPhongThi,SoChoNgoi)
	VALUES (@MaPhongThi,@MaLoaiPhongThi,@SoChoNgoi)
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_PT_Xoa]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_PT_Xoa] (
	@MaPhongThi nvarchar(50)
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaPhongThi IS NULL OR @MaPhongThi = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM PhongThi WHERE MaPhongThi = @MaPhongThi))
	BEGIN
		SET @Result = -2
		RETURN
	END

	DELETE FROM PhongThi
	WHERE MaPhongThi = @MaPhongThi
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_SV_Sua]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_SV_Sua] (
	@MaSinhVien	nvarchar(50)
	,@TenSinhVien	nvarchar(50)
	,@NgaySinh	date = NULL
	,@Result int
)
AS
BEGIN
	SET NOCOUNT ON
	
	IF @MaSinhVien IS NULL OR @MaSinhVien = '' OR @TenSinhVien IS NULL OR @TenSinhVien = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM SinhVien WHERE MaSinhVien = @MaSinhVien))
	BEGIN
		SET @Result = -2
		RETURN
	END

	UPDATE SinhVien
	SET	TenSinhVien = @TenSinhVien
		,NgaySinh = @NgaySinh
	WHERE MaSinhVien = @MaSinhVien
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_SV_Them]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_SV_Them] (
	@MaSinhVien	nvarchar(50)
	,@TenSinhVien	nvarchar(50)
	,@NgaySinh	date = NULL
	,@Result int OUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaSinhVien IS NULL OR @MaSinhVien = '' OR @TenSinhVien IS NULL OR @TenSinhVien = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT * FROM SinhVien WHERE MaSinhVien = @MaSinhVien)
	BEGIN
		SET @Result = -2
		RETURN
	END

	INSERT INTO SinhVien(MaSinhVien, TenSinhVien, NgaySinh) VALUES (@MaSinhVien, @TenSinhVien, @NgaySinh)
	SET @Result = 0
	RETURN
END

GO
/****** Object:  StoredProcedure [dbo].[proc_SV_Xoa]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_SV_Xoa] (
	@MaSinhVien nvarchar(50)
	,@Result int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @MaSinhVien IS NULL OR @MaSinhVien = ''
	BEGIN
		SET  @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM SinhVien WHERE MaSinhVien = @MaSinhVien))
	BEGIN
		SET @Result = -2
		RETURN
	END

	DELETE FROM SinhVien
	WHERE MaSinhVien = @MaSinhVien
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_TK_Dang_Nhap]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_TK_Dang_Nhap] (
	@UserName nvarchar(50)
	,@Password nvarchar(50)
	,@Type int output
)
AS
BEGIN
	SET NOCOUNT ON

	IF @UserName IS NULL OR
		@UserName = '' OR
		@Password IS NULL OR
		@Password = ''
	BEGIN
		SET @Type = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM TaiKhoan WHERE UserName = @UserName))
	BEGIN
		SET @Type = -2
		RETURN
	END

	IF @Password != (SELECT Password FROM TaiKhoan WHERE UserName = @UserName)
	BEGIN
		SET @Type = -3
		RETURN
	END

	SELECT @Type = Type FROM TaiKhoan WHERE UserName = @UserName
END

GO
/****** Object:  StoredProcedure [dbo].[proc_TK_Doi_Mat_Khau]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_TK_Doi_Mat_Khau] (
	@UserName nvarchar(50)
	,@Password nvarchar(50)
	,@Result int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @UserName IS NULL OR
		@UserName = '' OR
		@Password IS NULL OR
		@Password = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM TaiKhoan WHERE UserName = @UserName))
	BEGIN
		SET @Result = 1
		RETURN
	END

	UPDATE TaiKhoan
	SET Password = @Password
	WHERE UserName = @UserName
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_TK_Sua_Quyen]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_TK_Sua_Quyen] (
	@UserName nvarchar(50)
	,@Type int
	,@Result int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @UserName IS NULL OR
		@UserName = '' OR
		@Type IS NULL OR
		@Type = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT * FROM TaiKhoan WHERE UserName = @UserName))
	BEGIN
		SET @Result = 1
		RETURN
	END

	UPDATE TaiKhoan
	SET Type = @Type
	WHERE UserName = @UserName
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_TK_Tao]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_TK_Tao] (
	@UserName nvarchar(50)
	,@Password nvarchar(50)
	,@Type int
	,@Result int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @UserName IS NULL OR
		@UserName = '' OR
		@Password IS NULL OR
		@Password = '' OR
		@Type IS NULL OR
		@Type = ''
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF EXISTS(SELECT UserName FROM TaiKhoan WHERE UserName = @UserName)
	BEGIN
		SET @Result = 1
		RETURN
	END

	INSERT TaiKhoan(UserName,Password,Type) VALUES (@UserName, @Password, @Type)
	
	SET @Result = 0
END

GO
/****** Object:  StoredProcedure [dbo].[proc_TK_Xoa]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[proc_TK_Xoa](
	@UserName nvarchar(50)
	,@Result int OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON

	IF @UserName IS NULL OR
		@UserName = ''
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT(EXISTS(SELECT UserName FROM TaiKhoan WHERE UserName = @UserName))
	BEGIN
		SET @Result = 1
		RETURN
	END

	DELETE FROM TaiKhoan WHERE UserName = @UserName
	SET @Result = 0
END

GO
/****** Object:  UserDefinedFunction [dbo].[func_Danh_Sach_Lop_Hoc_Phan]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_Danh_Sach_Lop_Hoc_Phan](
	@NamHoc	nvarchar(50)
	,@HocKy	int
)
RETURNS @Res TABLE(
	MaLopHocPhan	nvarchar(50)
	,SoLuongSV	int
	,HinhThuc	nvarchar(50)
)
AS
BEGIN
	DECLARE	@Key	nvarchar(50)
	SET	@Key = CONCAT(@NamHoc,'.',@HocKy,'%')
	
	INSERT INTO @Res
	SELECT	DS.MaLopHocPhan, COUNT(MaSinhVien), LHP.HinhThucThi
	FROM	DanhSachSVLopHP AS DS
		JOIN LopHocPhan AS LHP ON DS.MaLopHocPhan = LHP.MaLopHocPhan
	WHERE	DS.MaLopHocPhan LIKE @Key
	GROUP BY DS.MaLopHocPhan, HinhThucThi
	ORDER BY MaLopHocPhan DESC

	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[func_Danh_Sach_Lop_Hoc_Phan_Trung]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_Danh_Sach_Lop_Hoc_Phan_Trung](
	@NamHoc	nvarchar(50)
	,@HocKy	int
)
RETURNS @Res TABLE(
	MaLopHocPhan1	nvarchar(50)
	,MaLopHocPhan2	nvarchar(50)
)
AS
BEGIN
	DECLARE	@Key	nvarchar(50)
	SET	@Key = CONCAT(@NamHoc,'.',@HocKy,'%')

	INSERT INTO @Res
	SELECT	DS1.MaLopHocPhan, DS2.MaLopHocPhan
	FROM	DanhSachSVLopHP AS DS1
		JOIN DanhSachSVLopHP AS DS2 ON DS1.MaSinhVien = DS2.MaSinhVien
	WHERE	DS1.MaLopHocPhan LIKE @Key
		AND DS2.MaLopHocPhan LIKE @Key
		AND DS1.MaLopHocPhan != DS2.MaLopHocPhan
	ORDER BY DS1.MaLopHocPhan DESC

	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[func_Kiem_Tra_Hoc_Cung]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_Kiem_Tra_Hoc_Cung] (
	@MaLopHocPhan1 nvarchar(50)
	,@MaLopHocPhan2 nvarchar(50)
)
RETURNS int
AS
BEGIN
	DECLARE @Res int

	SELECT	@Res = COUNT(MaSinhVien)
	FROM	DanhSachSVLopHP AS DS1
	WHERE	MaLopHocPhan = @MaLopHocPhan1
		AND MaSinhVien IN (SELECT	MaSinhVien
							FROM	DanhSachSVLopHP AS DS2
							WHERE	MaLopHocPhan = @MaLopHocPhan2
							)
	RETURN @Res
END

GO
/****** Object:  UserDefinedFunction [dbo].[func_Lich_Thi_TK_LHP]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_Lich_Thi_TK_LHP] (
	@MaLopHocPhan nvarchar(50)
	,@FromDate datetime
	,@ToDate datetime
)
RETURNS @Res TABLE (
	MaLichThi	nvarchar(50)
	,MaLopHocPhan	nvarchar(50)
	,NgayThi	datetime
	,ThoiGian	int
	,MaPhongThi	nvarchar(50)
	,HinhThuc	nvarchar(50)
)
AS
BEGIN
	IF @FromDate IS NULL
		SET @FromDate = DATEFROMPARTS(1900,1,1)

	IF @ToDate IS NULL
		SET @ToDate = DATEADD(YEAR, 1, GETDATE())
	
	INSERT INTO @Res
	SELECT	*
	FROM	LichThi
	WHERE	MaLopHocPhan LIKE CONCAT('%',@MaLopHocPhan,'%')
		AND NgayThi > @FromDate
		AND	NgayThi < @ToDate
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[func_Lich_Thi_TK_Ma]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_Lich_Thi_TK_Ma] (
	@MaLichThi nvarchar(50)
	,@FromDate datetime
	,@ToDate datetime
)
RETURNS @Res TABLE (
	MaLichThi	nvarchar(50)
	,MaLopHocPhan	nvarchar(50)
	,NgayThi	datetime
	,ThoiGian	int
	,MaPhongThi	nvarchar(50)
	,HinhThuc	nvarchar(50)
)
AS
BEGIN
	IF @FromDate IS NULL
		SET @FromDate = DATEFROMPARTS(1900,1,1)

	IF @ToDate IS NULL
		SET @ToDate = DATEADD(YEAR, 1, GETDATE())
	
	INSERT INTO @Res
	SELECT	*
	FROM	LichThi
	WHERE	MaLichThi LIKE CONCAT('%',@MaLichThi,'%')
		AND NgayThi > @FromDate
		AND	NgayThi < @ToDate
	RETURN
END

GO
/****** Object:  UserDefinedFunction [dbo].[func_Lich_Thi_TK_PT]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_Lich_Thi_TK_PT] (
	@MaPhongThi nvarchar(50)
	,@FromDate datetime
	,@ToDate datetime
)
RETURNS @Res TABLE (
	MaLichThi	nvarchar(50)
	,MaLopHocPhan	nvarchar(50)
	,NgayThi	datetime
	,ThoiGian	int
	,MaPhongThi	nvarchar(50)
	,HinhThuc	nvarchar(50)
)
AS
BEGIN
	IF @FromDate IS NULL
		SET @FromDate = DATEFROMPARTS(1900,1,1)

	IF @ToDate IS NULL
		SET @ToDate = DATEADD(YEAR, 1, GETDATE())
	
	INSERT INTO @Res
	SELECT	*
	FROM	LichThi
	WHERE	MaPhongThi LIKE CONCAT('%',@MaPhongThi,'%')
		AND NgayThi > @FromDate
		AND	NgayThi < @ToDate
	RETURN
END

GO
/****** Object:  Table [dbo].[DanhSachSVLopHP]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DanhSachSVLopHP](
	[MaSinhVien] [nvarchar](50) NOT NULL,
	[MaLopHocPhan] [nvarchar](50) NOT NULL,
	[LanHoc] [int] NOT NULL,
	[ThuocKHDT] [bit] NOT NULL,
 CONSTRAINT [PK_DanhSachSVLopHP] PRIMARY KEY CLUSTERED 
(
	[MaSinhVien] ASC,
	[MaLopHocPhan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [unique_LanHoc] UNIQUE NONCLUSTERED 
(
	[MaSinhVien] ASC,
	[MaLopHocPhan] ASC,
	[LanHoc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DieuKien]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DieuKien](
	[MaDieuKien] [nvarchar](50) NOT NULL,
	[TenDieuKien] [nvarchar](50) NOT NULL,
	[SoBuoiNghi] [int] NOT NULL,
 CONSTRAINT [PK_DieuKien] PRIMARY KEY CLUSTERED 
(
	[MaDieuKien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LichThi]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LichThi](
	[MaLichThi] [nvarchar](50) NOT NULL,
	[MaLopHocPhan] [nvarchar](50) NOT NULL,
	[NgayThi] [datetime] NOT NULL,
	[ThoiGian] [int] NOT NULL,
	[MaPhongThi] [nvarchar](50) NOT NULL,
	[HinhThuc] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_LichThi] PRIMARY KEY CLUSTERED 
(
	[MaLichThi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [unique_gio] UNIQUE NONCLUSTERED 
(
	[MaLopHocPhan] ASC,
	[NgayThi] ASC,
	[MaPhongThi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LoaiPhongThi]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoaiPhongThi](
	[MaLoaiPhongThi] [nvarchar](50) NOT NULL,
	[LoaiPhongThi] [nvarchar](50) NOT NULL,
	[ChiTiet] [nvarchar](50) NULL,
 CONSTRAINT [PK_LoaiPhongThi] PRIMARY KEY CLUSTERED 
(
	[MaLoaiPhongThi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LopHocPhan]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LopHocPhan](
	[MaLopHocPhan] [nvarchar](50) NOT NULL,
	[TenLopHocPhan] [nvarchar](50) NOT NULL,
	[SoTinChi] [int] NOT NULL,
	[HinhThucThi] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_LopHocPhan] PRIMARY KEY CLUSTERED 
(
	[MaLopHocPhan] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhongThi]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhongThi](
	[MaPhongThi] [nvarchar](50) NOT NULL,
	[MaLoaiPhongThi] [nvarchar](50) NULL,
	[SoChoNgoi] [int] NOT NULL,
 CONSTRAINT [PK_PhongThi] PRIMARY KEY CLUSTERED 
(
	[MaPhongThi] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SinhVien]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SinhVien](
	[MaSinhVien] [nvarchar](50) NOT NULL,
	[TenSinhVien] [nvarchar](50) NOT NULL,
	[NgaySinh] [date] NULL,
 CONSTRAINT [PK_SinhVien] PRIMARY KEY CLUSTERED 
(
	[MaSinhVien] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TaiKhoan]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TaiKhoan](
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](50) NULL,
	[Type] [int] NULL,
 CONSTRAINT [PK_TaiKhoan] PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [dbo].[func_DK_Tim_Kiem]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_DK_Tim_Kiem] (
	@In nvarchar(50)
)
RETURNS TABLE
AS
	RETURN(
		SELECT * 
		FROM DieuKien
		WHERE MaDieuKien LIKE CONCAT('%',@In,'%') OR TenDieuKien LIKE CONCAT('%',@In,'%')
	)

GO
/****** Object:  UserDefinedFunction [dbo].[func_DSSV_LHP_Tim_Kiem]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_DSSV_LHP_Tim_Kiem] (
	@MaSinhVien nvarchar(50)
	,@MaLopHocPhan nvarchar(50)
)
RETURNS TABLE
AS
	RETURN (
			SELECT *
			FROM	DanhSachSVLopHP
			WHERE	MaSinhVien LIKE CONCAT('%',@MaSinhVien,'%')
				OR MaLopHocPhan LIKE CONCAT('%',@MaLopHocPhan,'%')
			)

GO
/****** Object:  UserDefinedFunction [dbo].[func_LopHP_Tim_Kiem]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_LopHP_Tim_Kiem] (
	@In nvarchar(50)
)
RETURNS TABLE
AS
	RETURN(
		SELECT *
		FROM	LopHocPhan
		WHERE	MaLopHocPhan LIKE CONCAT('%',@In,'%') OR TenLopHocPhan LIKE CONCAT('%',@In,'%')
	)

GO
/****** Object:  UserDefinedFunction [dbo].[func_LPT_Tim_Kiem]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_LPT_Tim_Kiem] (
	@In nvarchar(50)
)
RETURNS TABLE
AS
	RETURN(
		SELECT	*
		FROM	LoaiPhongThi
		WHERE	MaLoaiPhongThi LIKE CONCAT('%',@In,'%')
			OR LoaiPhongThi LIKE CONCAT('%',@In,'%')
			OR ChiTiet LIKE CONCAT('%',@In,'%') 
	)

GO
/****** Object:  UserDefinedFunction [dbo].[func_PT_Tim_Kiem]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_PT_Tim_Kiem] (
	@In nvarchar(50)
)
RETURNS TABLE
AS
	RETURN(
		SELECT MaPhongThi, LoaiPhongThi.LoaiPhongThi, SoChoNgoi
		FROM PhongThi JOIN LoaiPhongThi ON PhongThi.MaLoaiPhongThi = LoaiPhongThi.MaLoaiPhongThi
		WHERE MaPhongThi LIKE CONCAT('%',@In,'%') OR LoaiPhongThi LIKE CONCAT('%',@In,'%')
	)

GO
/****** Object:  UserDefinedFunction [dbo].[func_SV_Tim_Kiem]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_SV_Tim_Kiem](
	@In nvarchar(50)
)
RETURNS TABLE
AS
	RETURN(
		SELECT *
		FROM SinhVien
		WHERE MaSinhVien LIKE CONCAT('%',@In,'%') OR TenSinhVien LIKE CONCAT('%',@In,'%')
	)

GO
/****** Object:  UserDefinedFunction [dbo].[func_TK_Tim_Kiem]    Script Date: 17/05/2021 8:59:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[func_TK_Tim_Kiem] (
	@UserName	nvarchar(50)
)
RETURNS TABLE
AS
	RETURN (
		SELECT	*
		FROM	TaiKhoan
		WHERE	UserName LIKE CONCAT('%',@UserName,'%')
	)

GO
ALTER TABLE [dbo].[DanhSachSVLopHP]  WITH CHECK ADD  CONSTRAINT [FK_DanhSachSVLopHP_LopHocPhan] FOREIGN KEY([MaLopHocPhan])
REFERENCES [dbo].[LopHocPhan] ([MaLopHocPhan])
GO
ALTER TABLE [dbo].[DanhSachSVLopHP] CHECK CONSTRAINT [FK_DanhSachSVLopHP_LopHocPhan]
GO
ALTER TABLE [dbo].[DanhSachSVLopHP]  WITH CHECK ADD  CONSTRAINT [FK_DanhSachSVLopHP_SinhVien] FOREIGN KEY([MaSinhVien])
REFERENCES [dbo].[SinhVien] ([MaSinhVien])
GO
ALTER TABLE [dbo].[DanhSachSVLopHP] CHECK CONSTRAINT [FK_DanhSachSVLopHP_SinhVien]
GO
ALTER TABLE [dbo].[LichThi]  WITH CHECK ADD  CONSTRAINT [FK_LichThi_LopHocPhan] FOREIGN KEY([MaLopHocPhan])
REFERENCES [dbo].[LopHocPhan] ([MaLopHocPhan])
GO
ALTER TABLE [dbo].[LichThi] CHECK CONSTRAINT [FK_LichThi_LopHocPhan]
GO
ALTER TABLE [dbo].[LichThi]  WITH CHECK ADD  CONSTRAINT [FK_LichThi_PhongThi] FOREIGN KEY([MaPhongThi])
REFERENCES [dbo].[PhongThi] ([MaPhongThi])
GO
ALTER TABLE [dbo].[LichThi] CHECK CONSTRAINT [FK_LichThi_PhongThi]
GO
ALTER TABLE [dbo].[PhongThi]  WITH CHECK ADD  CONSTRAINT [FK_PhongThi_LoaiPhongThi] FOREIGN KEY([MaLoaiPhongThi])
REFERENCES [dbo].[LoaiPhongThi] ([MaLoaiPhongThi])
GO
ALTER TABLE [dbo].[PhongThi] CHECK CONSTRAINT [FK_PhongThi_LoaiPhongThi]
GO
USE [master]
GO
ALTER DATABASE [XepLichThi] SET  READ_WRITE 
GO

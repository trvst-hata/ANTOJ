# ANTOJ — Hệ thống đánh giá mã nguồn tự động trực tuyến

## 1. Giới thiệu
Nền tảng đánh giá mã nguồn tự động hỗ trợ lập trình viên/sinh viên nộp bài (C++, Python...) và nhận kết quả chấm nhanh chóng, minh bạch.

## 2. Tech Stack & Thành viên
- **Backend:** FastAPI
- **Frontend:** React + Vite
- **Database:** SQL Server (Docker container: `antoj_mssql`)
- **Judge Worker:** Python
- **Thành viên:** Tài, Nhật, Mai Anh, Trúc

## 3. Quy ước Git & Jira
- Luôn rẽ nhánh từ `develop` (`feature/<MÃ-JIRA>-mo-ta`, `docs/...`, `fix/...`).
- Commit message và tiêu đề PR cần gắn mã thẻ Jira để tự động liên kết.
- Mọi thay đổi vào `develop` và `main` đều thông qua Pull Request và code review.

## 4. Khởi chạy môi trường local
- Khởi động các dịch vụ bằng Docker Compose (`docker-compose up -d`).
- Nạp schema/dữ liệu mẫu bằng `database/init_antoj.sql`.
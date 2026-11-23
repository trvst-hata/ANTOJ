IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'ANTOJ')
BEGIN
    CREATE DATABASE ANTOJ;
END
GO

USE ANTOJ;
GO

-- 1. Bảng Users
IF OBJECT_ID('Users', 'U') IS NULL
CREATE TABLE Users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    email NVARCHAR(100) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    role NVARCHAR(20) NOT NULL DEFAULT 'USER', -- 'USER', 'ADMIN'
    created_at DATETIME2 DEFAULT GETDATE()
);
GO

-- 2. Bảng Contests
IF OBJECT_ID('Contests', 'U') IS NULL
CREATE TABLE Contests (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX),
    start_time DATETIME2 NOT NULL,
    end_time DATETIME2 NOT NULL,
    created_by INT FOREIGN KEY REFERENCES Users(id),
    created_at DATETIME2 DEFAULT GETDATE()
);
GO

-- 3. Bảng Problems
IF OBJECT_ID('Problems', 'U') IS NULL
CREATE TABLE Problems (
    id INT IDENTITY(1,1) PRIMARY KEY,
    code NVARCHAR(30) NOT NULL UNIQUE, -- VD: APLUSB
    title NVARCHAR(200) NOT NULL,
    description NVARCHAR(MAX) NOT NULL,
    difficulty NVARCHAR(20) NOT NULL DEFAULT 'EASY', -- 'EASY', 'MEDIUM', 'HARD'
    time_limit_ms INT NOT NULL DEFAULT 1000,
    memory_limit_mb INT NOT NULL DEFAULT 256,
    contest_id INT NULL FOREIGN KEY REFERENCES Contests(id),
    created_by INT FOREIGN KEY REFERENCES Users(id),
    created_at DATETIME2 DEFAULT GETDATE()
);
GO

-- 4. Bảng TestCases
IF OBJECT_ID('TestCases', 'U') IS NULL
CREATE TABLE TestCases (
    id INT IDENTITY(1,1) PRIMARY KEY,
    problem_id INT NOT NULL FOREIGN KEY REFERENCES Problems(id) ON DELETE CASCADE,
    input_data NVARCHAR(MAX) NOT NULL,
    expected_output NVARCHAR(MAX) NOT NULL,
    is_sample BIT NOT NULL DEFAULT 0,
    order_index INT NOT NULL DEFAULT 1
);
GO

-- 5. Bảng Submissions
IF OBJECT_ID('Submissions', 'U') IS NULL
CREATE TABLE Submissions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL FOREIGN KEY REFERENCES Users(id),
    problem_id INT NOT NULL FOREIGN KEY REFERENCES Problems(id),
    language NVARCHAR(20) NOT NULL, -- 'cpp', 'python'
    source_code NVARCHAR(MAX) NOT NULL,
    status NVARCHAR(20) NOT NULL DEFAULT 'PENDING', -- 'PENDING', 'AC', 'WA', 'TLE', 'RE', 'CE'
    execution_time_ms INT NULL,
    memory_used_kb INT NULL,
    submitted_at DATETIME2 DEFAULT GETDATE()
);
GO

-- 6. Bảng SubmissionResults (chi tiết từng test case)
IF OBJECT_ID('SubmissionResults', 'U') IS NULL
CREATE TABLE SubmissionResults (
    id INT IDENTITY(1,1) PRIMARY KEY,
    submission_id INT NOT NULL FOREIGN KEY REFERENCES Submissions(id) ON DELETE CASCADE,
    test_case_id INT NOT NULL FOREIGN KEY REFERENCES TestCases(id),
    status NVARCHAR(20) NOT NULL,
    execution_time_ms INT NULL,
    actual_output NVARCHAR(MAX) NULL
);
GO

-- Seed dữ liệu mẫu
IF NOT EXISTS (SELECT 1 FROM Users WHERE username = 'admin')
BEGIN
    INSERT INTO Users (username, email, password_hash, role)
    VALUES ('admin', 'admin@antoj.local', '$2b$12$placeholderhashforadminaccount', 'ADMIN');
END
GO

IF NOT EXISTS (SELECT 1 FROM Problems WHERE code = 'APLUSB')
BEGIN
    DECLARE @adminId INT = (SELECT TOP 1 id FROM Users WHERE username = 'admin');
    INSERT INTO Problems (code, title, description, difficulty, time_limit_ms, memory_limit_mb, created_by)
    VALUES (
        'APLUSB',
        N'Tính tổng A + B',
        N'Cho hai số nguyên A và B. Hãy in ra tổng của chúng.',
        'EASY',
        1000,
        256,
        @adminId
    );

    DECLARE @probId INT = SCOPE_IDENTITY();
    INSERT INTO TestCases (problem_id, input_data, expected_output, is_sample, order_index)
    VALUES
        (@probId, N'1 2', N'3', 1, 1),
        (@probId, N'100 250', N'350', 0, 2),
        (@probId, N'-5 10', N'5', 0, 3);
END
GO
-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 18, 2026 at 12:31 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lectra`
--

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `body` text NOT NULL,
  `is_emergency` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `title`, `body`, `is_emergency`, `created_at`) VALUES
(1, 'Welcome to Lectra', 'Welcome to the new academic year at our institution', 0, '2026-06-02 11:52:22'),
(2, 'Exam Registration', 'Exam registration closes this Friday', 0, '2026-06-02 11:52:22'),
(3, 'Campus Closure', 'Due to severe weather, campus will be closed tomorrow', 1, '2026-06-02 11:52:22');

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `timetable_id` int(11) NOT NULL,
  `confirmed_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`id`, `student_id`, `timetable_id`, `confirmed_at`) VALUES
(1, 3, 1, '2026-06-02 11:52:22'),
(2, 3, 2, '2026-06-02 11:52:22'),
(3, 3, 3, '2026-06-02 11:52:22'),
(4, 3, 4, '2026-06-02 11:52:22'),
(5, 6, 1, '2026-06-10 13:50:14'),
(6, 6, 2, '2026-06-11 14:44:25'),
(7, 6, 3, '2026-06-11 15:43:56'),
(8, 6, 4, '2026-06-16 10:57:32');

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL,
  `title` varchar(200) NOT NULL,
  `lecturer_id` int(11) DEFAULT NULL,
  `department_id` int(11) NOT NULL,
  `created_at` timestamp(6) NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `code`, `title`, `lecturer_id`, `department_id`, `created_at`) VALUES
(1, 'CS101', 'Introduction to Programming', 2, 1, '2026-06-04 15:35:49.489157'),
(2, 'CS201', 'Data Structures and Algorithms', 2, 1, '2026-06-04 15:35:49.489157'),
(3, 'CS301', 'Database Systems', 2, 1, '2026-06-04 15:35:49.489157'),
(4, 'EE101', 'Circuit Analysis', 2, 2, '2026-06-04 15:35:49.489157'),
(10, '1S420', 'Computer Application Package 2', 2, 1, '2026-06-04 15:35:49.489157'),
(11, 'GNS402', 'System Analysis 2', 2, 1, '2026-06-04 15:36:38.399727');

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `faculty_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`, `faculty_id`) VALUES
(1, 'Computer Science', 1),
(2, 'Electrical Engineering', 2),
(3, 'Science Laboratory Technology', 3);

-- --------------------------------------------------------

--
-- Table structure for table `faculties`
--

CREATE TABLE `faculties` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `created_at` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `faculties`
--

INSERT INTO `faculties` (`id`, `name`, `created_at`) VALUES
(1, 'Faculty of Computing', '2026-06-09 13:00:00.828430'),
(2, 'Faculty of Environmental', '2026-06-11 14:32:02.228323'),
(3, 'Faculty of Science', '2026-06-09 13:00:00.828430'),
(4, 'Faculty of Technology', '2026-06-09 13:00:00.828430');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `type` enum('reminder','cancellation','change','general','info','warning','alert') NOT NULL DEFAULT 'general',
  `target_role` enum('admin','lecturer','student','all') NOT NULL DEFAULT 'all',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `title`, `message`, `type`, `target_role`, `created_at`, `is_active`) VALUES
(1, 'System Update', 'The system will undergo maintenance this weekend', 'general', 'all', '2026-06-02 11:52:22', 1),
(2, 'Important Notice', 'Final exam schedule has been posted', 'reminder', 'student', '2026-06-02 11:52:22', 1),
(3, 'Emergency Alert', 'Campus closed due to weather conditions', 'cancellation', 'all', '2026-06-02 11:52:22', 1),
(4, 'Class Notice', 'GNS402 starts in 30 minutes', 'reminder', 'student', '2026-06-07 11:14:42', 1);

-- --------------------------------------------------------

--
-- Table structure for table `timetable`
--

CREATE TABLE `timetable` (
  `id` int(11) NOT NULL,
  `course_id` int(11) NOT NULL,
  `day` enum('Monday','Tuesday','Wednesday','Thursday','Friday') NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `venue` varchar(100) NOT NULL,
  `week` tinyint(3) UNSIGNED NOT NULL,
  `created_at` timestamp(6) NOT NULL DEFAULT current_timestamp(6) ON UPDATE current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `timetable`
--

INSERT INTO `timetable` (`id`, `course_id`, `day`, `start_time`, `end_time`, `venue`, `week`, `created_at`) VALUES
(1, 1, 'Monday', '09:00:00', '11:00:00', 'Room 101', 1, '2026-06-16 10:14:26.455142'),
(2, 2, 'Monday', '14:00:00', '16:00:00', 'Room 201', 1, '2026-06-16 10:14:26.455142'),
(3, 3, 'Tuesday', '10:00:00', '12:00:00', 'Lab A', 1, '2026-06-16 10:14:26.455142'),
(4, 4, 'Tuesday', '13:00:00', '15:00:00', 'Room 301', 1, '2026-06-16 10:14:26.455142'),
(5, 1, 'Monday', '09:00:00', '11:00:00', 'Room 101', 2, '2026-06-16 10:14:26.455142'),
(6, 2, 'Monday', '14:00:00', '16:00:00', 'Room 201', 2, '2026-06-16 10:14:26.455142'),
(7, 3, 'Tuesday', '10:00:00', '12:00:00', 'Lab A', 2, '2026-06-16 10:14:26.455142'),
(8, 4, 'Tuesday', '13:00:00', '15:00:00', 'Room 301', 2, '2026-06-16 10:14:26.455142');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','lecturer','student') NOT NULL DEFAULT 'student',
  `department_id` int(11) DEFAULT NULL,
  `device_token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`, `department_id`, `device_token`) VALUES
(1, 'Admin User', 'admin@lectra.edu', '$2y$10$M6usJqP1FXxU/nKG4Yx.9uOHT46/f53qQPpZyPZFY4kSJvVgcvZwa', 'admin', 1, NULL),
(2, 'Dr. Jane Smith', 'lecturer@lectra.edu', '$2y$10$M6usJqP1FXxU/nKG4Yx.9uOHT46/f53qQPpZyPZFY4kSJvVgcvZwa', 'lecturer', 1, NULL),
(3, 'John Ayoola', 'student@lectra.edu', '$2y$10$M6usJqP1FXxU/nKG4Yx.9uOHT46/f53qQPpZyPZFY4kSJvVgcvZwa', 'student', 1, NULL),
(4, 'Adetola Olatunde', 'maliksucess@gmail.com', '$2y$10$00wpDNul8ulgTN274oni8O1OjlCS4bzUuk.JZY.A1ipazYq2dO2ui', 'student', 1, NULL),
(5, 'Ashborne', 'ashborne@gmail.com', '$2y$10$Wv4BLAkxjriSlm9WPG3RjOnTqmRxpg1fx5KTWCpiC5LwQFXXhb72y', 'admin', NULL, NULL),
(6, 'Daniel', 'daniel@gmail.com', '$2y$10$NUnn/690TgKeCvhS2TuCR.bAcwPk.21O2Tq426inXJmkSvPL7x6em', 'student', 2, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_attendance` (`student_id`,`timetable_id`),
  ADD KEY `timetable_id` (`timetable_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `lecturer_id` (`lecturer_id`),
  ADD KEY `department_id` (`department_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `faculty_id` (`faculty_id`);

--
-- Indexes for table `faculties`
--
ALTER TABLE `faculties`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `timetable`
--
ALTER TABLE `timetable`
  ADD PRIMARY KEY (`id`),
  ADD KEY `course_id` (`course_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `department_id` (`department_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `faculties`
--
ALTER TABLE `faculties`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `timetable`
--
ALTER TABLE `timetable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attendance_ibfk_2` FOREIGN KEY (`timetable_id`) REFERENCES `timetable` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `courses`
--
ALTER TABLE `courses`
  ADD CONSTRAINT `courses_ibfk_1` FOREIGN KEY (`lecturer_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `courses_ibfk_2` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `departments`
--
ALTER TABLE `departments`
  ADD CONSTRAINT `departments_ibfk_1` FOREIGN KEY (`faculty_id`) REFERENCES `faculties` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `timetable`
--
ALTER TABLE `timetable`
  ADD CONSTRAINT `timetable_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

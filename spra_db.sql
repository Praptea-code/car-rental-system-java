-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 10, 2026 at 03:58 AM
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
-- Database: `spra_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `name`, `description`, `created_at`) VALUES
(1, 'Skincare', 'Cleansers, serums, moisturisers', '2026-04-14 15:46:29'),
(2, 'Makeup', 'Foundation, blush, eyeshadow', '2026-04-14 15:46:29'),
(3, 'Fragrance', 'Perfumes and body mists', '2026-04-14 15:46:29'),
(4, 'Lips', 'Lipstick, lip liner, gloss', '2026-04-14 15:46:29'),
(5, 'Eyes', 'Mascara, eyeliner, eyeshadow', '2026-04-14 15:46:29'),
(6, 'Tools', 'Brushes, sponges, applicators', '2026-04-14 15:46:29');

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `message_id` int(11) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `subject` varchar(200) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` (`message_id`, `first_name`, `last_name`, `email`, `subject`, `message`, `created_at`) VALUES
(1, 'Prapti', 'Bhattarai', 'praptibhattarai63@gmail.com', 'Product Question', 'How to order?', '2026-04-16 04:00:03'),
(2, 'Sabrina', 'Pradhan', 'praptibhattarai63@gmail.com', 'Product Question', 'How does the product work?', '2026-04-16 05:25:00'),
(3, 'Resha', 'Kojuah', 'resha@gmail.com', 'Collaboration', 'Hi i waant t1o coll1ab i 1cannot 1type 1wit1hout 1 nu1m1ber 1 1i ha2ve  2a k2id2 name2d saq2briqng2', '2026-04-16 05:39:18');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `full_name` varchar(120) NOT NULL DEFAULT '',
  `phone` varchar(20) NOT NULL DEFAULT '',
  `address` varchar(255) NOT NULL DEFAULT '',
  `city` varchar(80) NOT NULL DEFAULT '',
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('ORDERED','SHIPPED','DELIVERED','CANCELLED') NOT NULL DEFAULT 'ORDERED',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `full_name`, `phone`, `address`, `city`, `total_amount`, `status`, `created_at`) VALUES
(1, 3, 'Prapti Bhattarai', '9878789008', 'sinamangal', 'kathamandu', 42163.00, 'SHIPPED', '2026-05-04 09:39:17'),
(2, 3, 'Prapti Bhattarai', '9868706777', 'Sinamanagal', 'Kathmandu', 22635.00, 'DELIVERED', '2026-05-07 03:57:22'),
(3, 3, 'Prapti Bhattarai', '9868706777', 'Sinamanagal', 'Kathmandu', 15090.00, 'SHIPPED', '2026-05-07 03:59:45'),
(4, 3, 'Prapti Bhattarai', '9868706777', 'Sinamanagal', 'Kathmandu', 3459.50, 'SHIPPED', '2026-05-07 04:08:20'),
(5, 3, 'Prapti Bhattarai', '9868706777', 'Sinamanagal', 'Kathmandu', 942.00, 'SHIPPED', '2026-05-07 04:12:27'),
(6, 3, 'Prapti Bhattarai', '9868706777', 'Sinamanagal', 'Kathmandu', 22635.00, 'SHIPPED', '2026-05-07 20:59:29'),
(7, 3, 'Prapti Bhattarai', '9878789008', 'sinamangal', 'kathamandu', 19966.00, 'ORDERED', '2026-05-08 05:25:07'),
(8, 2, 'Prapti Bhattarai', '9868706777', 'Sinamanagal', 'Kathmandu', 11983.00, 'ORDERED', '2026-05-09 14:17:31');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`item_id`, `order_id`, `product_id`, `quantity`, `price`) VALUES
(1, 1, 1, 2, 3459.50),
(2, 1, 2, 3, 7545.00),
(3, 1, 6, 1, 4438.00),
(4, 2, 2, 1, 7545.00),
(5, 2, 3, 1, 2438.00),
(6, 2, 7, 1, 3222.00),
(7, 2, 5, 1, 3336.00),
(8, 2, 8, 3, 2119.00),
(9, 3, 2, 2, 7545.00),
(10, 4, 1, 1, 3459.50),
(11, 5, 4, 1, 942.00),
(12, 4, 1, 1, 3459.50),
(13, 5, 4, 1, 942.00),
(14, 6, 2, 3, 7545.00),
(15, 7, 2, 2, 7545.00),
(16, 7, 3, 2, 2438.00),
(17, 8, 6, 1, 4438.00),
(18, 8, 2, 1, 7545.00);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `token_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `token` varchar(64) NOT NULL,
  `expires_at` datetime NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `password_reset_tokens`
--

INSERT INTO `password_reset_tokens` (`token_id`, `user_id`, `token`, `expires_at`, `used`, `created_at`) VALUES
(2, 2, '952815ec955247969b6ef7386a7e04a3', '2026-05-09 15:27:40', 0, '2026-05-09 20:42:40');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `old_price` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT 0,
  `image_path` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `is_featured` tinyint(1) DEFAULT 0,
  `is_bestseller` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `name`, `description`, `price`, `old_price`, `stock`, `image_path`, `category_id`, `is_featured`, `is_bestseller`, `created_at`) VALUES
(1, 'Rose Petal Perfume', 'Light floral fragrance with rose and jasmine notes.', 3459.50, 4575.00, 30, 'rosePetalPerfume.jpg', 3, 1, 1, '2026-04-14 15:46:29'),
(2, 'Elemis Hydrating Day Cream', 'Deep hydration serum with hyaluronic acid & vitamin C.', 7545.00, 8755.00, 47, 'elemisCream.jpg', 1, 1, 0, '2026-04-14 15:46:29'),
(3, 'Velvet Rose Lipstick', 'Long-lasting matte lipstick in velvet rose shade.', 2438.00, NULL, 40, 'velvetRoseLipstick.jpg', 4, 1, 0, '2026-04-14 15:46:29'),
(4, 'Pro Brush Set', '8-piece professional makeup brush set.', 942.00, 1058.00, 24, 'brush.jpg', 6, 1, 0, '2026-04-14 15:46:29'),
(5, 'Blush Palette', '6-shade warm blush palette for all skin tones.', 3336.00, NULL, 35, 'blushPalette.jpg', 2, 0, 0, '2026-04-14 15:46:29'),
(6, 'Glow Moisturiser', 'Lightweight daily moisturiser with SPF 30.', 4438.00, 5446.00, 60, 'moisturizer.jpg', 1, 0, 0, '2026-04-14 15:46:29'),
(7, 'Nude Lip Combo', 'Define and shape lips with this nude liner.', 3222.00, NULL, 45, 'lipCombo.jpg', 4, 0, 0, '2026-04-14 15:46:29'),
(8, 'Pearl Eye Ring', 'Subtle shimmer eyeshadow for day looks.', 2119.00, 0.00, 200, 'eyeRing.jpg', 5, 0, 0, '2026-04-14 15:46:29'),
(9, 'Vitamin C Brightening Serum', 'Potent vitamin C serum that fades dark spots and evens skin tone.', 5299.00, 6200.00, 40, 'vitaminC.jpg', 1, 0, 0, '2026-05-10 01:29:33'),
(10, 'Retinol Night Repair Cream', 'Overnight retinol cream that reduces fine lines and renews skin texture.', 6850.00, 7999.00, 25, 'retinol.jpg', 1, 0, 0, '2026-05-10 01:29:33'),
(11, 'Soothing Aloe Toner', 'Alcohol-free toner with aloe vera and green tea to calm and hydrate.', 2199.00, NULL, 55, 'aloe.jpg', 1, 0, 0, '2026-05-10 01:29:33'),
(12, 'Oud Noir Eau de Parfum', 'Rich and smoky oud fragrance with hints of amber and sandalwood.', 7299.00, 8500.00, 20, 'perfume.jpg', 3, 0, 0, '2026-05-10 01:29:33'),
(13, 'Glass Lip Gloss', 'High-shine non-sticky gloss that gives a plumped glass-lip effect.', 1599.00, NULL, 70, 'lipgloss.jpg', 4, 0, 0, '2026-05-10 01:29:34'),
(14, 'Volumizing Curl Mascara', '24-hour volumizing mascara that lifts and curls lashes without clumping.', 2599.00, 2999.00, 48, 'curl.jpg', 5, 0, 0, '2026-05-10 01:29:34'),
(15, 'Rose Quartz Facial Roller', 'Cooling rose quartz roller that depuffs, boosts circulation and aids serum absorption.', 2299.00, 2799.00, 35, 'roller.jpg', 6, 0, 0, '2026-05-10 01:29:34');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` tinyint(4) NOT NULL CHECK (`rating` between 1 and 5),
  `title` varchar(120) DEFAULT NULL,
  `body` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`review_id`, `product_id`, `user_id`, `rating`, `title`, `body`, `created_at`) VALUES
(1, 1, 3, 5, NULL, 'Great product', '2026-05-02 13:03:22');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `google_id` varchar(128) DEFAULT NULL,
  `role` enum('ADMIN','USER') DEFAULT 'USER',
  `is_active` tinyint(1) DEFAULT 1,
  `login_attempts` int(11) DEFAULT 0,
  `locked_until` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `username`, `email`, `phone`, `password`, `birthdate`, `google_id`, `role`, `is_active`, `login_attempts`, `locked_until`, `created_at`) VALUES
(1, 'Spra', 'Admin', 'spraadmin', 'admin@spra.com', '+97798112345678', 'Hqih11AThbgNmykMUKk6lA==:SWcIua9eE6C4pcJ0875+htXNKQNY3RCh3eL3D3nmHLY=', NULL, NULL, 'ADMIN', 1, 0, NULL, '2026-04-14 15:46:29'),
(2, 'Prapti', 'Bhattarai', 'prapteaaarshnav', 'praptibhattarai63@gmail.com', '+9779868706777', 'xJp4HTaqTSHcWzUTRQZ6DQ==:whcfzvK+3tN0jj+lfiywWGttP8uRqbImjJn++h7XhUM=', '2023-02-18', '101440861597030645368', 'USER', 1, 0, NULL, '2026-04-14 17:49:51'),
(3, 'Prapti', 'Bhattarai', 'oteateateao', 'praptibhattarai60@gmail.com', '+9779868706778', 'UvoS8lYg8ej4gb4oVzc2pg==:07I5OMcuv/SJjCEHcipnccoIubCmuWSz6C4F5vpYc5s=', '2026-04-02', NULL, 'USER', 1, 0, NULL, '2026-04-16 03:59:31'),
(4, 'Sabrina', 'Pradhan', 'Gladiolusbat', 'pradhansabrina32@gmail.com', '+9779808752050', 'moCc1PPVCMXaa71ALxFWcg==:lwYhGoglqrp6NPU/7url4SobhoTXVN8jBvj74jTozz8=', '2006-08-25', NULL, 'USER', 1, 0, NULL, '2026-04-16 05:34:13'),
(5, 'Aarshnav', 'Kc', 'aarshnavkc3', 'aarshnav@gmail.com', '+9779868706007', 'fVFyJ3WrlJ/Z6pA3JwAblg==:gJKzQ7ObOQKgUW/jKAQEQ/7LkeH9fiWY6Ke681hBT2c=', '2026-04-01', NULL, 'USER', 1, 0, NULL, '2026-04-16 06:15:22');

-- --------------------------------------------------------

--
-- Table structure for table `wishlists`
--

CREATE TABLE `wishlists` (
  `wishlist_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wishlists`
--

INSERT INTO `wishlists` (`wishlist_id`, `user_id`, `product_id`, `created_at`) VALUES
(4, 3, 2, '2026-05-07 20:34:51');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`message_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`token_id`),
  ADD UNIQUE KEY `token` (`token`),
  ADD KEY `fk_prt_user` (`user_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD UNIQUE KEY `uq_user_product` (`user_id`,`product_id`),
  ADD KEY `fk_review_product` (`product_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone` (`phone`);

--
-- Indexes for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`wishlist_id`),
  ADD UNIQUE KEY `uq_user_product` (`user_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  MODIFY `token_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `wishlist_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD CONSTRAINT `fk_prt_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL;

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_review_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_review_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

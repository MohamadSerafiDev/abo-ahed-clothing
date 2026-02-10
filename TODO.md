# Backend and Frontend Synchronization TODO List

This document outlines the tasks required to synchronize the Flutter frontend with the Node.js backend.

## 1. Model Mismatches

-   [ ] **`cart_model.dart`:**
    -   [ ] Remove `totalPrice` from `CartModel` as it's not provided by the `getMyCart` endpoint. It should be calculated on the client-side from the `items`.
    -   [ ] Change `userId` to `customer` to match the backend schema or adjust the `fromJson` to handle both `user` and `customer`. Let's stick to the backend's `customer`.
    -   [ ] Add `_id` to `CartItemModel` and change `product` to `productId` of type String. The backend sends the populated product, but for toJson it is better to have the id.

-   [ ] **`order_model.dart`:**
    -   [ ] Remove the `screenshot` field from `OrderModel`. This belongs to the `Payment` concept, which is handled separately on the backend.
    -   [ ] The `createOrder` on the backend returns `{ message, orderId, totalAmount }`. The frontend `order_api.dart#checkout` must be updated to handle this response instead of expecting a full `OrderModel`. The cubit should be updated as well.

-   [ ] **`notification_model.dart`:**
    -   [ ] Remove the `type` and `data` fields as they don't exist in the backend `Notification` schema.
    -   [ ] Change `userId` to `recipient` to match the backend.

-   [ ] **Create `shipping_model.dart`:**
    -   [ ] Create a new `ShippingModel` in `lib/models/shipping_model.dart` to match the backend `Shipping` schema (`order`, `courier`, `addressDetails`, `status`, `trackingNumber`, `notes`).
    -   [ ] The `order` and `courier` fields should be of type `OrderModel` and `UserModel` respectively, as the backend populates them.

## 2. API Service (Provider) Mismatches

-   [ ] **`cart_api.dart`:**
    -   [ ] In `getCart`, the backend returns the cart object directly. Adjust the parsing from `response.data['cart']` to `response.data`.

-   [ ] **`product_api.dart`:**
    -   [ ] In `getProductById`, the backend returns the product object directly (merged with media). Adjust parsing from `response.data['product']` to `response.data`.
    -   [ ] In `createProduct` and `updateProduct`, the backend returns the product in `updatedProduct` or `product`. The parsing should be adjusted.

-   [ ] **`order_api.dart`:**
    -   [ ] As stated in the model mismatches, update the `checkout` method to handle the `{ message, orderId, totalAmount }` response. It should not return an `OrderModel`.
    -   [ ] In `verifyPayment`, the backend returns the order in `order`. Adjust the parsing from `response.data['order']` to match the actual response.

-   [ ] **`shipping_api.dart`:**
    -   [ ] Update `getMyDeliveries` to parse a list of `ShippingModel` (once created) instead of `OrderListResponse`.
    -   [ ] Update `updateShippingStatus` to return a `ShippingModel` instead of an `OrderModel`.

## 3. Bloc/Cubit Logic

-   [ ] **`OrderCubit`:**
    -   [ ] Adjust the `checkout` method to handle the new response from `order_api.dart`. The state should perhaps hold the `orderId` and `message` instead of a full `OrderModel`.

-   [ ] **`ShippingCubit`:**
    -   [ ] Update the cubit and its states (`DeliveriesLoaded`) to use the new `ShippingModel` instead of `OrderModel`.

## 4. Minor Fixes & Refinements

-   [ ] Review all `fromJson` factories to ensure they gracefully handle null or missing fields, providing default values where appropriate (e.g., empty lists for arrays).
-   [ ] Ensure `copyWith` methods are present and correct in all models.
-   [ ] Verify that all API calls handle potential errors and exceptions gracefully.

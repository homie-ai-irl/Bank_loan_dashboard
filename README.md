# Bank Loan Dashboard

Báo cáo phân tích danh mục khoản vay cá nhân, được xây dựng bằng Power BI. Dashboard tập trung theo dõi số lượng hồ sơ, giá trị khoản vay và khoản thanh toán đã nhận, đồng thời phân tích hiệu quả khoản vay theo trạng thái và các nhóm khách hàng.

## Nội dung thư mục

| Tệp | Mô tả |
|---|---|
| `Dash_Board.pbix` | Báo cáo Power BI. Mở tệp bằng Power BI Desktop để xem và tương tác với dashboard. |
| `financial_loan.csv` | Dữ liệu nguồn gồm 38.576 hồ sơ và 24 trường; ngày giải ngân (`issue_date`) trong dữ liệu từ 01-01-2021 đến 12-12-2021. |
| `Query_check.sql` | Các truy vấn SQL Server dùng để tính toán và kiểm tra những chỉ số khoản vay. |
| `TERMINOLOGIES_DATA.docx` | Tài liệu giải thích các trường và thuật ngữ trong dữ liệu. |

## Chỉ số và phân tích

Các truy vấn trong `Query_check.sql` bao gồm:

- Tổng số hồ sơ, tổng số tiền giải ngân và tổng số tiền đã nhận.
- Lãi suất trung bình và tỷ lệ nợ trên thu nhập (DTI) trung bình.
- So sánh theo tháng (MoM) cho số hồ sơ, tiền giải ngân, tiền đã nhận, lãi suất và DTI.
- Chỉ số theo trạng thái khoản vay:
  - **Good loan:** trạng thái `Fully Paid` hoặc `Current`.
  - **Bad loan:** trạng thái `Charged Off`.
- Phân tích theo tháng, tiểu bang, kỳ hạn, thâm niên làm việc, mục đích vay và tình trạng sở hữu nhà.

## Mở báo cáo

1. Cài đặt và mở **Power BI Desktop**.
2. Mở `Dash_Board.pbix`.
3. Nếu Power BI yêu cầu nguồn dữ liệu, cập nhật đường dẫn đến `financial_loan.csv` hoặc cấu hình lại kết nối tương ứng.
4. Chọn **Refresh** để nạp lại dữ liệu sau khi nguồn đã được cấu hình.

## Chạy truy vấn SQL

`Query_check.sql` sử dụng cú pháp SQL Server và giả định dữ liệu đã được nạp vào bảng `Bankloandata`. Để chạy:

1. Tạo hoặc chọn cơ sở dữ liệu trong SQL Server.
2. Nạp `financial_loan.csv` vào bảng `Bankloandata`, bảo đảm tên và kiểu dữ liệu các cột tương thích với tiêu đề CSV.
3. Mở `Query_check.sql` trong SQL Server Management Studio (SSMS) hoặc công cụ SQL Server tương thích, chọn đúng cơ sở dữ liệu rồi chạy truy vấn.

Các truy vấn đang lọc MTD theo tháng 12 và PMTD theo tháng 11 thông qua số tháng, không lọc năm hoặc ngày chốt cụ thể. Điều này phù hợp với phạm vi dữ liệu năm 2021 hiện có; cần điều chỉnh điều kiện thời gian nếu dùng dữ liệu nhiều năm hoặc muốn tính MTD theo ngày cập nhật.

## Trường dữ liệu

CSV bao gồm thông tin hồ sơ và khách hàng (`id`, `member_id`, `application_type`, `emp_title`, `emp_length`, `annual_income`), đặc điểm khoản vay (`loan_amount`, `term`, `installment`, `int_rate`, `grade`, `sub_grade`, `purpose`), trạng thái và thanh toán (`loan_status`, `total_payment`, `total_acc`) cùng các trường ngày, địa lý và xác minh. Tham khảo `TERMINOLOGIES_DATA.docx` để xem diễn giải chi tiết.

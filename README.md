# SPI-Controlled Temperature Logger with UART Interface

Modular Verilog system simulating an SPI-based temperature sensor, storing data in a FIFO, and transmitting over UART — built for embedded IoT-style applications.

This project simulates a fully integrated modular Verilog system that:
- Interfaces with a simulated 8-bit SPI ADC sensor
- Logs the 10 most recent temperature readings
- Sends the readings over UART as ASCII characters
- Shows system status using LED logic

## 📦 Features
- SPI Master FSM to fetch temperature every second
- Shift register-based rolling FIFO to store recent data
- UART Transmitter to send ASCII data over serial
- LED indicators for logging status and FIFO state

## 📁 Folder Structure

spi-uart-temp-logger/

├── src/ - RTL design modules

├── sim/ - Testbench and simulation files

---

## 📌 Modules

| Module             | Description                           |
|--------------------|---------------------------------------|
| `spi_adc_sim`      | Dummy 8-bit SPI ADC temperature sensor|
| `spi_master`       | FSM that fetches data periodically    |
| `shift_register_10`| FIFO storing last 10 values           |
| `uart_tx`          | UART Transmitter (8N1, ASCII format)  |
| `temp_logger_top`  | Top-level module connecting all blocks|

## 🧪 Testbench
The `tb_temp_logger.v` simulates:
- Clock and reset
- 10-second run with data logging and UART transmission

---

- Sample Waveform: <img width="1563" height="563" alt="Screenshot 2025-07-30 174554" src="https://github.com/user-attachments/assets/1f19278b-dbaa-4aa5-aee5-f21b8334b93f" />



# OT Scheduling Application Blueprint

## Overview

This document outlines the architecture and features of the OT Scheduling Application, a Flutter-based mobile app designed to streamline the management of operating theaters, staff, and surgical schedules.

## Implemented Features

### Core Application

*   **Theming:** A comprehensive theming system with light and dark modes, custom fonts (`GoogleFonts.oswald`, `GoogleFonts.roboto`, `GoogleFonts.openSans`), and a consistent color scheme.
*   **Navigation:** A tab-based navigation system with three main screens: "Daily OT Scheduling," "Sunday & Leave," and "Master Data."

### User Interface
*   **Debug Banner:** Removed the debug banner from the top of the app.

### Master Data Management

*   **Staff Management:**
    *   Add and remove staff members (nurses, technicians, etc.).
    *   Input validation to ensure required fields are filled.
    *   Visual feedback on successful actions.
*   **Surgeon Management:**
    *   Add and remove surgeons.
    *   Input validation and user feedback.

### Sunday & Leave Management

*   **Leave Management:**
    *   Schedule leave for staff members using a date picker.
    *   View a list of upcoming leave days.
*   **Sunday Roster:**
    *   Generate a weekly roster for staff working on Sundays.
    *   The roster automatically excludes staff members who are on leave.

### Daily OT Scheduling

*   **OT Selection:**
    *   Select from 10 available operating theaters for the day.
*   **Surgery Scheduling:**
    *   Schedule surgeries for the selected OTs.
    *   Assign a patient name, procedure, and surgeon to each surgery.
*   **Staff Allocation:**
    *   Allocate available staff to the scheduled surgeries.

## Final Plan

The application is now feature-complete. The following steps have been accomplished:

1.  **Project Setup:** Initialized a Flutter project and set up the basic application structure.
2.  **Theming and Navigation:** Implemented a complete theming system and tab-based navigation.
3.  **Master Data:** Implemented the "Master Data Management" screen with staff and surgeon management.
4.  **Sunday & Leave:** Implemented the "Sunday & Leave Management" screen with leave scheduling and Sunday roster generation.
5.  **Daily Scheduling:** Implemented the "Daily OT Scheduling" screen with OT selection, surgery scheduling, and staff allocation.
6.  **Blueprint Update:** Updated this `blueprint.md` file to reflect the final state of the application.

//
//  HorizontalCalendarView.swift
//  HorizontalCalendar
//
//  Created by Cute Puppy on 2024/3/2.
//

import SwiftUI

struct HorizontalCalendarView: View {
    let calendar = Calendar.current
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(getWeekdayString(for: selectedDate-1))
                    .font(.title)
                    .contentTransition(.numericText(value: selectedDate.timeIntervalSinceReferenceDate))
                    .bold()
                    .padding()
                Spacer()
                
                Text(getCurrentYearMonth(for: selectedDate))
                    .padding(.trailing, 16)
            }
            .padding(.bottom, 4)
            
            ScrollViewReader{ scrollView in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(getMonthDates(for: Date()), id: \.self) { date in
                            DateView(date: date, isSelected: date == selectedDate)
                                .onTapGesture {
                                    withAnimation(.linear(duration: 0.2)) {
                                        self.selectedDate = date
                                        scrollView.scrollTo(date,anchor: .center)
                                    }
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        Spacer()
    }
    
    
    func getMonthDates(for date: Date) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        for day in 1...range.count {
            let components = DateComponents(year: year, month: month, day: day)
            if let date = calendar.date(from: components) {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    func getWeekdayString(for date: Date) -> String {
        let weekday = calendar.component(.weekday, from: date)
        return calendar.weekdaySymbols[weekday % 7]
    }
    
    func getCurrentYearMonth(for date: Date) -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MMMM /yyyy"
        return dateFormatter.string(from: date)
    }
    
}

struct DateView: View {
    let date: Date
    let isSelected: Bool
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text(getWeekdayString(for: date-1))
                .font(.subheadline)
                .foregroundColor(.secondary)
            VStack {
                Text(dateFormatter.string(from: date))
                    .font(.title2)
                    .fontWeight(isSelected ? .bold : .regular)
                    .foregroundColor(isSelected ? Color.black : Color.primary)
                
            }
            .frame(width: 40, height: 40)
            .background(isSelected ? Color.white : Color.black)
            .cornerRadius(99)
            .foregroundColor(.white)
        }
    }
    
    func getWeekdayString(for date: Date) -> String {
        let weekday = Calendar.current.component(.weekday, from: date)
        return Calendar.current.shortWeekdaySymbols[weekday % 7]
    }
}

#Preview {
    HorizontalCalendarView()
}

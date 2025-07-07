//
//  NewInsightsView.swift
//  napzzz
//
//  Created by Morris Romagnoli on 07/07/2025.
//

import SwiftUI

struct NewInsightsView: View {
    @StateObject private var dataManager = InsightsDataManager.shared
    @State private var selectedTab = 0
    @State private var selectedDate = Date()
    @State private var showingDatePicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                InsightsHeaderView(
                    selectedDate: selectedDate,
                    showingDatePicker: $showingDatePicker
                )
                
                // Tab Selection
                StatisticsTabView(selectedTab: $selectedTab)
                
                // Content
                TabView(selection: $selectedTab) {
                    // Today Tab
                    TodayInsightsContent(
                        session: dataManager.getSessionForDate(selectedDate),
                        selectedDate: selectedDate
                    )
                    .tag(0)
                    
                    // Week Tab
                    WeekInsightsContent(
                        sessions: dataManager.getSessionsForWeek(from: selectedDate),
                        selectedDate: selectedDate
                    )
                    .tag(1)
                    
                    // Month Tab
                    MonthInsightsContent(
                        sessions: dataManager.sleepSessions,
                        selectedDate: selectedDate
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .background(Color.napzzzBackground)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingDatePicker) {
                DatePickerSheet(selectedDate: $selectedDate)
            }
        }
    }
}

// MARK: - Header View
struct InsightsHeaderView: View {
    let selectedDate: Date
    @Binding var showingDatePicker: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Sleep Insights")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.napzzzTextPrimary)
                
                Button(action: {
                    showingDatePicker = true
                }) {
                    HStack(spacing: 8) {
                        Text(formatDate(selectedDate))
                            .font(.headline)
                            .foregroundColor(.napzzzTextSecondary)
                        
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(.napzzzAccent)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "info.circle")
                    .font(.title2)
                    .foregroundColor(.napzzzTextSecondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Statistics Tab View
struct StatisticsTabView: View {
    @Binding var selectedTab: Int
    
    private let tabs = ["Today", "Week", "Month"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(tabs[index])
                            .font(.system(size: 16, weight: selectedTab == index ? .semibold : .medium))
                            .foregroundColor(selectedTab == index ? .napzzzTextPrimary : .napzzzTextSecondary)
                        
                        Rectangle()
                            .fill(selectedTab == index ? Color.napzzzAccent : Color.clear)
                            .frame(height: 2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
    }
}

// MARK: - Today Insights Content
struct TodayInsightsContent: View {
    let session: SleepSessionData?
    let selectedDate: Date
    
    var body: some View {
        ScrollView {
            if let session = session {
                VStack(spacing: 24) {
                    // Sleep Quality Score
                    SleepQualityCard(session: session)
                    
                    // Sleep Phases Graph
                    SleepPhasesGraphCard(session: session)
                    
                    // Sleep Phase Breakdown
                    SleepPhaseBreakdownView(session: session)
                    
                    // Sleep Metrics
                    SleepMetricsView(session: session)
                    
                    // Sound Events
                    if !session.detectedSounds.isEmpty {
                        SoundEventsView(session: session)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            } else {
                NoSleepDataView(date: selectedDate)
            }
        }
    }
}

// MARK: - Week Insights Content
struct WeekInsightsContent: View {
    let sessions: [SleepSessionData]
    let selectedDate: Date
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Week Overview")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.napzzzTextPrimary)
                
                // Week summary content would go here
                Text("Coming soon...")
                    .foregroundColor(.napzzzTextSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

// MARK: - Month Insights Content
struct MonthInsightsContent: View {
    let sessions: [SleepSessionData]
    let selectedDate: Date
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Month Overview")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.napzzzTextPrimary)
                
                // Month summary content would go here
                Text("Coming soon...")
                    .foregroundColor(.napzzzTextSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}

// MARK: - No Sleep Data View
struct NoSleepDataView: View {
    let date: Date
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "moon.zzz.fill")
                .font(.system(size: 60))
                .foregroundColor(.napzzzSecondary)
            
            Text("No Sleep Data")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.napzzzTextPrimary)
            
            Text("No sleep session recorded for this date")
                .font(.body)
                .foregroundColor(.napzzzTextSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 100)
    }
}

// MARK: - Sleep Quality Card
struct SleepQualityCard: View {
    let session: SleepSessionData
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sleep Quality")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.napzzzTextPrimary)
            
            ZStack {
                // Background circle
                Circle()
                    .stroke(Color.napzzzTextSecondary.opacity(0.2), lineWidth: 8)
                    .frame(width: 150, height: 150)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: Double(session.sleepQuality.score) / 100)
                    .stroke(
                        LinearGradient(
                            colors: [Color.napzzzPrimary, Color.napzzzAccent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("\(session.sleepQuality.score)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.napzzzTextPrimary)
                    
                    Text(session.sleepQuality.description)
                        .font(.caption)
                        .foregroundColor(.napzzzTextSecondary)
                }
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Color.napzzzCardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Sleep Phases Graph Card
struct SleepPhasesGraphCard: View {
    let session: SleepSessionData
    @State private var animateGraph = false
    @State private var animateLabels = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Sleep Phases")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.napzzzTextPrimary)
            
            // Enhanced Sleep Phases Graph with improved labels
            EnhancedSleepPhasesGraph(
                session: session,
                animateGraph: animateGraph,
                animateLabels: animateLabels
            )
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(Color.napzzzCardBackground)
        .cornerRadius(16)
        .onAppear {
            // Staggered animations
            withAnimation(.easeInOut(duration: 0.6).delay(0.2)) {
                animateLabels = true
            }
            withAnimation(.easeInOut(duration: 0.8).delay(0.4)) {
                animateGraph = true
            }
        }
    }
}

// MARK: - Enhanced Sleep Phases Graph
struct EnhancedSleepPhasesGraph: View {
    let session: SleepSessionData
    let animateGraph: Bool
    let animateLabels: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Enhanced Phase Labels with professional styling
            GeometryReader { geometry in
                ZStack {
                    // Phase labels with enhanced styling
                    HStack(spacing: 0) {
                        ForEach(SleepPhaseType.allCases, id: \.self) { phase in
                            VStack(spacing: 8) {
                                // Enhanced label with glass morphism effect
                                SleepPhaseLabelContent(
                                    phase: phase,
                                    isAnimated: animateLabels
                                )
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.leading, 70) // Increased padding for better positioning
                }
            }
            .frame(height: 60)
            
            // Main sleep graph
            GeometryReader { geometry in
                let totalDuration = session.timeInBed
                let width = geometry.size.width
                
                HStack(spacing: 0) {
                    ForEach(session.sleepPhases) { phase in
                        let phaseWidth = width * (phase.duration / totalDuration)
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(phase.type.color),
                                        Color(phase.type.color).opacity(0.7)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: animateGraph ? phaseWidth : 0)
                            .animation(
                                .easeInOut(duration: 0.8)
                                .delay(Double(session.sleepPhases.firstIndex(of: phase) ?? 0) * 0.1),
                                value: animateGraph
                            )
                    }
                }
                .frame(height: 60)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.napzzzTextSecondary.opacity(0.2), lineWidth: 1)
                )
            }
            .frame(height: 60)
            
            // Time markers
            HStack {
                Text(formatTime(session.startTime))
                    .font(.caption2)
                    .foregroundColor(.napzzzTextSecondary)
                
                Spacer()
                
                let middleTime = session.startTime.addingTimeInterval(session.timeInBed / 2)
                Text(formatTime(middleTime))
                    .font(.caption2)
                    .foregroundColor(.napzzzTextSecondary)
                
                Spacer()
                
                Text(formatTime(session.endTime))
                    .font(.caption2)
                    .foregroundColor(.napzzzTextSecondary)
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Sleep Phase Label Content
struct SleepPhaseLabelContent: View {
    let phase: SleepPhaseType
    let isAnimated: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            // Enhanced label with glass morphism and glow effects
            Text(phase.displayName.uppercased())
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .tracking(0.5)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    ZStack {
                        // Glass morphism background
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(phase.color).opacity(0.3),
                                        Color(phase.color).opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.3),
                                                Color.white.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                        
                        // Animated glow effect
                        if isAnimated {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color(phase.color).opacity(0.4),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 30
                                    )
                                )
                                .scaleEffect(1.2)
                                .opacity(0.8)
                                .animation(
                                    .easeInOut(duration: 2.0)
                                    .repeatForever(autoreverses: true),
                                    value: isAnimated
                                )
                        }
                    }
                )
                .shadow(
                    color: Color(phase.color).opacity(0.3),
                    radius: isAnimated ? 8 : 4,
                    x: 0,
                    y: 2
                )
                .scaleEffect(isAnimated ? 1.0 : 0.8)
                .opacity(isAnimated ? 1.0 : 0.0)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.8)
                    .delay(Double(SleepPhaseType.allCases.firstIndex(of: phase) ?? 0) * 0.1),
                    value: isAnimated
                )
            
            // Accent dot with glow
            Circle()
                .fill(Color(phase.color))
                .frame(width: 6, height: 6)
                .shadow(color: Color(phase.color), radius: isAnimated ? 4 : 2)
                .scaleEffect(isAnimated ? 1.0 : 0.5)
                .opacity(isAnimated ? 1.0 : 0.0)
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.7)
                    .delay(Double(SleepPhaseType.allCases.firstIndex(of: phase) ?? 0) * 0.1 + 0.2),
                    value: isAnimated
                )
        }
    }
}

// MARK: - Sleep Phase Breakdown View
struct SleepPhaseBreakdownView: View {
    let session: SleepSessionData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Phase Breakdown")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.napzzzTextPrimary)
            
            VStack(spacing: 12) {
                ForEach(session.sleepPhases) { phase in
                    HStack {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color(phase.type.color))
                                .frame(width: 12, height: 12)
                            
                            Text(formatDuration(phase.duration))
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.napzzzTextPrimary)
                        }
                        
                        Spacer()
                        
                        Text(phase.type.displayName)
                            .font(.caption)
                            .foregroundColor(.napzzzTextSecondary)
                    }
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(Color.napzzzCardBackground)
        .cornerRadius(16)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

// MARK: - Sleep Metrics View
struct SleepMetricsView: View {
    let session: SleepSessionData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sleep Metrics")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.napzzzTextPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                MetricCard(
                    title: "Time in Bed",
                    value: formatDuration(session.timeInBed),
                    icon: "bed.double.fill",
                    color: .napzzzPrimary
                )
                
                MetricCard(
                    title: "Sleep Efficiency",
                    value: "\(Int(session.sleepEfficiency * 100))%",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .napzzzAccent
                )
                
                MetricCard(
                    title: "Avg Noise",
                    value: "\(Int(session.averageNoiseLevel)) dB",
                    icon: "waveform",
                    color: .napzzzSecondary
                )
                
                MetricCard(
                    title: "Sound Events",
                    value: "\(session.detectedSounds.count)",
                    icon: "speaker.wave.2.fill",
                    color: .orange
                )
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(Color.napzzzCardBackground)
        .cornerRadius(16)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        return "\(hours)h \(minutes)m"
    }
}

// MARK: - Metric Card
struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.napzzzTextPrimary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.napzzzTextSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.napzzzBackground)
        .cornerRadius(12)
    }
}

// MARK: - Sound Events View
struct SoundEventsView: View {
    let session: SleepSessionData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sound Events")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.napzzzTextPrimary)
            
            VStack(spacing: 12) {
                ForEach(session.detectedSounds.prefix(5)) { sound in
                    SoundEventRow(sound: sound)
                }
                
                if session.detectedSounds.count > 5 {
                    Text("+ \(session.detectedSounds.count - 5) more events")
                        .font(.caption)
                        .foregroundColor(.napzzzTextSecondary)
                        .padding(.top, 8)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 20)
        .background(Color.napzzzCardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Sound Event Row
struct SoundEventRow: View {
    let sound: SoundEvent
    
    var body: some View {
        HStack(spacing: 12) {
            Text(sound.type.emoji)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(sound.type.rawValue)
                    .font(.headline)
                    .foregroundColor(.napzzzTextPrimary)
                
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { index in
                        Rectangle()
                            .fill(Double(index) / 5.0 <= sound.intensity ? Color.napzzzAccent : Color.napzzzTextSecondary.opacity(0.3))
                            .frame(width: 4, height: 12)
                    }
                }
            }
            
            Spacer()
            
            Text(formatTime(sound.timestamp))
                .font(.caption)
                .foregroundColor(.napzzzTextSecondary)
        }
        .padding(.vertical, 8)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Date Picker Sheet
struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NewInsightsView()
        .preferredColorScheme(.dark)
}
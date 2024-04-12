//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by chuchu on 4/2/24.
//  Copyright © 2024 com.chuchu. All rights reserved.
//

import WidgetKit
import SwiftUI

import Features
import Core

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), percent: 0, link: nil)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), percent: getPercent(), link: getRandomLink())
    
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = [SimpleEntry(date: Date(), percent: getPercent(), link: getRandomLink())]
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
  
  private func getRandomLink() -> Core.Link? {
    let linkList = UserDefaultsManager.shared.linkList
    let filterdList = linkList.filter { !$0.isRemoved }
    
    return filterdList.randomElement()
  }
  
  private func getPercent() -> CGFloat {
    let baseLinkList = UserDefaultsManager.shared.linkList.filter { !$0.isRemoved }
    let readedLinkList = baseLinkList.filter { $0.isWrittenCount != 0 }
    guard !baseLinkList.isEmpty else { return 0.0 }
    
    return Double(readedLinkList.count) / Double(baseLinkList.count)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let percent: CGFloat
  let link: Core.Link?
  
  init(date: Date, percent: CGFloat, link: Core.Link? = nil) {
    self.date = date
    self.percent = percent
    self.link = link
  }
}

struct WidgetExtensionEntryView : View {
  var entry: Provider.Entry
  @Environment(\.widgetFamily) var family: WidgetFamily
  
  var body: some View {
    ZStack {
      Color(.code6)
      
      switch family {
      case .systemSmall: smallView
      case .systemMedium: mediumView
      default: EmptyView()
      }
    }
    .widgetURL(URL(string: entry.link?.url ?? "www.naver.com"))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  var smallView: some View {
    GeometryReader { proxy in
      let size = (proxy.size.height / 3)
      
      VStack(alignment: .leading, spacing: 4) {
        HStack(alignment: .top, spacing: 8) {
          CircularProgressView(
            style: CircularProgressView.Style.default,
            percentage: .constant(entry.percent)
          )
          .frame(width: size, height: size)
          
          Text(I18N.widgetTitle.forceCharWrapping)
            .font(Font(FontManager.shared.pretendard(weight: .medium, size: 12)))
            .padding(.top, 8)
            .lineLimit(2)
          
          Spacer()
        }
        Spacer()
        
        getLinkView(link: entry.link)
      }
      .padding()
    }
  }
  
  @ViewBuilder
  var mediumView: some View {
    GeometryReader { proxy in
      let size = (proxy.size.height / 3)
      
      VStack(alignment: .leading, spacing: 4) {
        HStack(alignment: .top, spacing: 8) {
          CircularProgressView(
            style: CircularProgressView.Style.default,
            percentage: .constant(entry.percent)
          )
          .frame(width: size, height: size)
          
          VStack(spacing: 16) {
            Text(I18N.widgetTitle.forceCharWrapping)
              .font(Font(FontManager.shared.pretendard(weight: .medium, size: 14)))
              .lineLimit(2)
              .frame(maxWidth: .infinity, alignment: .leading)
            
            getLinkView(link: entry.link)
          }
        }
      }
      .padding()
    }
  }
  
  @ViewBuilder
  private func getLinkView(link: Core.Link?) -> some View {
    if let link {
      VStack(alignment: .leading, spacing: 4) {
        if link.content?.title?.isEmpty == false { dataTextView(link.content?.title ?? "") }
        if link.url?.isEmpty == false { dataTextView(link.url ?? "") }
      }
    } else { dataTextView(I18N.addLinkTitle) }
  }
  
  @ViewBuilder
  private func dataTextView(_ text: String) -> some View {
    Text(text)
      .lineLimit(1)
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(Font(FontManager.shared.pretendard(weight: .light, size: 12)))
  }
}

struct WidgetExtension: Widget {
  let kind: String = "WidgetExtension"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      if #available(iOS 17.0, *) {
        WidgetExtensionEntryView(entry: entry)
          .containerBackground(.fill, for: .widget)
      } else {
        WidgetExtensionEntryView(entry: entry)
      }
    }
    .configurationDisplayName(I18N.recommendationLink)
    .description(I18N.widgetSubtitle)
    .supportedFamilies([.systemSmall, .systemMedium])
    .disableContentMarginsIfNeeded()
  }
}

extension WidgetConfiguration {
  func disableContentMarginsIfNeeded() -> some WidgetConfiguration {
    if #available(iOSApplicationExtension 17.0, *) {
      return self.contentMarginsDisabled()
    } else {
      return self
    }
  }
}

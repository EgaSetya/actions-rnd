//
//  tncView.swift
//  Bythen
//
//  Created by edisurata on 26/10/24.
//

import SwiftUI
import MarkdownUI

struct TermsOfServiceView: View {
    @State var isAccepted: Bool = false
    @State var isAcceptedContact: Bool = false
    
    @State var shouldDisableAcceptButton: Bool = true
    
    var didAccept: (_ tos: Bool, _ contactable: Bool) -> Void = {_,_  in }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Text("Terms of Service")
                    .font(.foundersGrotesk(.medium, size: 28))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(28)
                ScrollView {
                    Markdown("""
                    ## **Introduction and Agreement to Terms**

                    Last Updated: 14 January 2025

                    Welcome to bythen! We’re excited for you to explore our platform. These Terms of Use (“Terms”) are here to guide your experience with bythen’s products, services, and features,  including everything our platform offers.

                    These Terms apply to your use of bythen’s products, services, and features, accessible through our website, mobile site, mobile apps for iOS and Android, and desktop applications (collectively, the “Platform”). No matter how you access bythen, these Terms govern your interactions with our services.

                    **Definitions**:

                    * **bythen, We, Our, Us**: Refers to Tomo Labs, which holds exclusive rights granted by bythen Pte. Ltd.  
                    * **You, Your**: Refers to the user of bythen Platform.  
                    * **bythen Platform**: The digital ecosystem encompassing apps and services offering features such as Dojo, My Collection, Chat Room, Studio for content creation, along with Bytes Hive Program, that is accessible through Website and Mobile Apps.  
                    * **bythen Products**: Includes bythen Chip, bythen Pod, bythen Card, any original or collaborative collections, and additional products that bythen may introduce in the future.  
                    * **bythen Original**: Refers to a unique NFT and 3D avatar collection created by bythen, with designs originated by and intellectual property owned by bythen.  
                    * **Character IP:** Refers to legally protected intellectual property rights covering original and distinctive character designs, allowing for their exclusive use in media, branding, merchandising, or digital identity applications.  
                    * **Derivative Artwork:** Refers to creative works that are based on or adapted from existing intellectual property (IP).  
                    * **Derivative Collection:** Refers to a group of derivative artworks created by bythen as 3D Avatars based on third-party intellectual property (IP).  
                    * **3D Avatar**: Refers to all 3D Avatars created by bythen, covering both bythen Original, derivative Character IP, and collaboration IP.  
                    * **Licensor:** Refers to the entity granting the rights to use certain intellectual property (IP), such as bythen, derivative collections, or other IP Owner.   
                    * **Licensee:** Refers to the individual or entity receiving the rights to use the IP under specified conditions.

                    By signing up or otherwise using our Platform, you confirm that you accept these Terms and agree to follow them, along with any applicable laws and regulations. If you disagree with any part of these Terms, please refrain from using our Platform.

                    **Arbitration and Class Action Waiver**: PLEASE NOTE: THESE TERMS INCLUDE AN ARBITRATION CLAUSE AND CLASS ACTION WAIVER. By agreeing, you accept to settle any disputes through binding arbitration rather than court, and you waive the right to join in class actions.

                    **Contact Us**: For questions about these Terms or your use of the Platform, please reach out to us at hello@bythen.ai.

                    ---

                    ### **User Eligibility**

                    **Age Requirement**: Users must be at least 18 years old to access and use bythen’s services independently. Users under the age of 18 may access the Platform only with verifiable consent from a parent or legal guardian, which may involve submitting parental contact information or other necessary verification. By accessing the Platform, you confirm that you meet these age requirements or have the required consent. bythen does not permit users under the age of 18 to create accounts or engage with the Platform without such consent.

                    **Regional and Content-Specific Restrictions**: bythen’s services and products may be subject to regional restrictions due to local regulations or intellectual property rights limitations. In some cases, access to specific collections, products, or features may be restricted or unavailable in certain regions. For example, particular licensed content may not be accessible in select countries. bythen reserves the right to restrict or terminate access to certain services or content where local regulations or licensing agreements apply.

                    ---

                    ### **1. Our Services**

                    bythen platform offers a comprehensive suite of products and services designed to empower users to build and express their digital identities as virtual creators. Our platform provides tools, features, and a supportive ecosystem that allows users to bring their AI-powered avatars to life as chatbots and digital personas. With bythen’s resources, users can create content, participate in live events as their avatars, and join a community of creators to expand their skills and influence in the digital space.

                    Our offerings include:

                    * **bythen Studio**:  
                      * **Content Creation Tool**: A versatile platform where users can produce videos and images as their 3D Avatars (Bytes) for impactful, shareable content.  
                      * **Virtual Camera (Desktop App)**: A desktop application enabling users to bring their avatars to life in real-time, creating a virtual presence for online meetings, live streams, and other live digital settings.  
                    * **bythen AI and Dojo**:  
                      * **bythen AI**: A chatroom environment where users can interact with their avatars in a personalized, conversational setting, creating an engaging digital companion or alter ego.  
                      * **Dojo**: A customization tool for personalizing an avatar’s personality and traits, allowing users to shape a unique digital identity that reflects their individuality.  
                    * **Bytes Hive**: Bytes Hive is a vibrant community of creators. Within the program, aspiring creators have the opportunity to learn, explore new opportunities, and network with like-minded individuals. Through Bytes Hive, users can access valuable resources, participate in reward programs, and collaborate within a community to grow their skills and expand their reach as digital creators.  
                    * **bythen Store**: An online marketplace where users can purchase bythen products, including digital assets, collectibles, and exclusive content to enhance their creative toolkit.

                    bythen continuously evolves its services and offerings to align with our mission of empowering virtual creators and enhancing user experience. We may add, remove, or modify functionalities as needed to keep our platform innovative and compliant with industry standards. Our commitment is to support and inspire users in their journey as digital creators.

                    ---

                    ### **2. bythen Products**

                    bythen offers a range of innovative digital products. Each product serves a distinct purpose within the bythen ecosystem, catering to different user needs—from access to 3D Avatars and exclusive collections to opportunities for trading and personalization. Here's an overview of the key bythen products and their features:

                    * **bythen Chip:** As bythen's genesis NFT collection, the bythen Chip provides holders with early access to the platform, exclusive airdrops, and priority for future IP collections and token distributions.  
                    * **bythen Pod**: bythen Pod is an NFT that grants holders access to 3D Avatars derived from established external character IP.   
                    * **bythen Card**: bythen Card is an NFT that can be redeemed for 3D Avatars from bythen’s current and upcoming IP Collection.  
                    * **Original Collections**: Refers to a unique NFT and 3D avatar collection created by bythen, with designs originated by and intellectual property owned by bythen.  
                    * **Collaborative Collections**: NFTs designed in partnership with third-party IPs. These collections bring diverse styles and branding opportunities, broadening the creative horizons for users.

                    All bythen products are transferable, allowing users to share or gift as needed. However, only the bythen Chip and bythen Pod can be listed on marketplaces for trading, while the bythen Card is restricted from being sold and is limited to view-only listings on third-party marketplaces.

                    ---

                    ### **3. Membership & Subscriptions**

                    **A. Registration Obligations**  
                    To access and use certain bythen platform services, you must register and create an account, becoming a bythen Member. By registering, you agree to provide accurate, complete, and current information as prompted by the registration forms. Users under 18 may register and use bythen’s services only with verifiable consent from a parent or legal guardian. Registration data and related personal information are managed in accordance with our Privacy Policy.

                    **B. Account Security**  
                    As a bythen Member, you are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to notify bythen promptly of any unauthorized access or security breaches related to your account. bythen is not liable for any loss or damage resulting from your failure to comply with these responsibilities.

                    **C. General Use and Storage Practices**  
                    bythen may establish general practices and limits regarding the use of its services, including data retention periods, storage allocations, and inactive account policies. Data, content, or settings associated with your account may be retained only for the duration specified by bythen’s data retention policies. Once data exceeds the retention period, bythen may delete or archive it in accordance with these policies.

                    bythen reserves the right to terminate accounts that remain inactive for extended periods and to adjust general usage and storage practices, including retention policies and storage allocations, at its discretion.

                    **D. Email Notifications and Communications**  
                    By becoming a bythen Member, you consent to receive communications from bythen, including notifications about your account, updates to services, and occasional marketing messages. You may unsubscribe from marketing communications at any time by following the opt-out instructions included in those emails. Note that account notifications, such as security or service updates, are essential communications and cannot be opted out of. Membership and subscription benefits are non-transferable.

                    ---

                    ### **4. Privacy and Data Security**

                    You acknowledge that bythen may implement general practices and limits related to the use of its services. These practices may include, but are not limited to, setting maximum retention periods for data and content stored within bythen’s services, as well as establishing storage limits allocated to individual accounts on bythen’s servers.

                    bythen is not liable for the deletion or failure to store any data or content that extends beyond these retention periods or storage limits. You further acknowledge that bythen reserves the right to deactivate or terminate accounts that remain inactive for prolonged periods, as determined by bythen’s policies.

                    These general practices and limits are subject to change at bythen’s sole discretion, with or without prior notice to users.

                    ### **5. Conditions to Use**

                    To maintain a respectful and compliant environment, users must adhere to the following rules regarding the use of bythen’s services, assets, and intellectual property.

                    **A. Ownership and Licensing of 3D Assets**  
                    bythen provides proprietary 3D models and customization services for use within its platform. While bythen owns the 3D assets created on its platform, intellectual property rights to the characters themselves may belong to the original IP holder or NFT owner, depending on the Intellectual Property licensing terms of each collection. Users are required to respect these original Intellectual Property (“IP”) terms.

                    **B. User Consent for Avatar Creation and Marketing Use**  
                    By using the bythen platform, you consent to bythen creating a 3D Avatar based on your original NFT character. This includes rendering and customization of the avatar within bythen’s services, in accordance with the original IP terms. Additionally, bythen reserves the right to use 3D Avatars for marketing and promotional purposes on bythen’s platform or in external media, unless otherwise specified by the user. Users who wish to object to this usage can contact us at hello@bythen.ai.

                    **C. Prohibited Uses and Activities**  
                    Users are prohibited from engaging in the following activities:

                    * **Unauthorized Use**: Unauthorized use of bythen’s proprietary tools, systems, or 3D assets outside of the permitted scope, including sublicensing or transferring rights to third parties for profit or redistribution of tools or assets not intended for public use or sharing.  
                    * **Illegal or Harmful Conduct**: Engaging in illegal activities or conduct harmful to others, including harassment, abuse, or actions that violate local or international laws.  
                    * **Misrepresentation**: Misrepresenting affiliation with bythen or infringing on bythen’s intellectual property or that of original IP holders.

                    **D. Respect for Original IP and Contextual Sensitivity**

                    1. **Offensive or Defamatory Content**: The use of any 3D Avatars, including original or derivative collections, must not be associated with offensive, obscene, or defamatory content. This includes hate speech, violence, or discriminatory language based on race, gender, sexual orientation, religion, or other protected characteristics.  
                    2. **Restricted Contexts**: 3D Avatars or Specific IP may not be used in association with adult content, hate speech, or promotion of violence and must respect the terms of the original IP holder.  
                    3. **Controversial Associations**: Certain collections may prohibit use in highly controversial contexts that could imply endorsement or harm the reputation of the IP owner. In such cases, users should adhere to the IP owner's guidelines regarding acceptable uses. Educational discussions may be permitted as long as they remain respectful and constructive.

                    **E. Commercial Use Permissions**  
                    Users may use their 3D Avatars for commercial purposes, such as creating content in collaboration with brands, provided this use aligns with the original IP holder’s terms for the NFT collection.

                    bythen encourages constructive expression and respectful dialogue within the community and reserves the right to restrict or terminate access for users who engage in prohibited activities.

                    ### **6. Warranty, Liability, and Indemnification** 

                    bythen provides the services on an "as-is" basis, without any express or implied warranties, including, but not limited to, warranties of merchantability or fitness for a particular purpose. bythen does not guarantee uninterrupted or error-free service.

                    bythen is not liable for any indirect, incidental, or consequential damages resulting from the use of the platform, content posted by users, or actions by third parties. Users acknowledge that bythen bears no responsibility for any financial losses, including those resulting from account suspensions, terminations, payment delays, or price adjustments within the platform.

                    Users agree to indemnify and hold bythen harmless from any claims, losses, or damages arising from their use of the platform. 

                    ### **7. Changes to Terms**

                    bythen may change its Terms of Use at any time with proper notice to users. When changes are made, they will be posted on this page. Users will be notified if changes affect the nature of their relationship with bythen, and continued use of the platform constitutes agreement to the updated terms.

                    ### **8. Termination** 

                    1. Grounds for Termination: 

                    The license granted herein may be terminated by the IP Owner or Licensor upon:

                    * Breach of any term of this Agreement by Licensee.  
                    * Use of the IP that harms the reputation of the IP Owner.  
                    * Other violations as determined by the IP Owner or Licensor  
                    2. Consequences of Termination: 

                    Upon termination of the license, the following consequences will apply:

                    * Loss of Access: The Licensee will lose all rights to access the bythen platform and all related services. This includes, but is not limited to, access to NFT-related features, content, and any other services (stated in “Permitted Usage for NFT Holders”) provided by Licensor.  
                    * Forfeiture of Rights: The Licensee will forfeit all rights granted under this Agreement, including the rights to use the Derivative Artwork. The Licensee will no longer be permitted to display, share, or use the Derivative Artwork in any capacity.  
                    * Return or Destruction of Derivative Artwork: The Licensee may be required to return or destroy any copies of the Derivative Artwork in their possession, as directed by the IP Owner or Licensor.

                    ### **9. Dispute Resolution and Arbitration Agreement**

                    1. **Agreement to Arbitrate**

                    This Dispute Resolution section, referred to as the “Arbitration Agreement,” sets out that any disputes or claims arising between you and bythen, whether related to these Terms of Use, the Services, or any aspect of the relationship or transactions between us, will be resolved exclusively through final and binding arbitration, rather than in court. Users may still pursue individual claims in small claims court if the claims qualify. This Arbitration Agreement does not restrict users from reporting issues to government agencies that may act against bythen on users' behalf. By agreeing to these terms, both bythen and the user waive the right to a jury trial or to participate in a class action. Arbitration shall be governed by the rules of the Singapore International Arbitration Centre (SIAC), with Singapore law as the governing law.

                    2. **Prohibition of Class Actions and Non-Individualized Relief**

                    YOU AND bythen AGREE TO RESOLVE DISPUTES ON AN INDIVIDUAL BASIS AND WAIVE THE RIGHT TO PARTICIPATE IN ANY CLASS OR REPRESENTATIVE ACTIONS. The arbitrator may not consolidate or join more than one person’s claims or preside over any class proceedings, without mutual consent. The arbitrator may only award relief to the individual party involved, and solely to the extent required to resolve that party’s specific claim(s).

                    3. **Pre-Arbitration Dispute Resolution**

                    bythen encourages informal dispute resolution whenever possible. Most user concerns can be resolved by contacting our customer support at hello@bythen.ai. If informal resolution does not suffice, users intending to pursue arbitration must send a “Notice of Dispute” to bythen at hello@bythen.ai. This Notice should describe the nature of the claim or dispute and specify the desired relief. If the claim remains unresolved within 60 days of receipt, either party may initiate arbitration proceedings.

                    4. **Arbitration Procedures**

                    Arbitration will be conducted by a neutral arbitrator under SIAC rules and procedures, modified where needed by this Agreement. All issues, including scope and enforceability of this Arbitration Agreement, are for the arbitrator to decide. The arbitrator can award the same individual damages and relief available in court. Unless mutually agreed otherwise, arbitration hearings will take place in a location convenient to both parties. For claims under $10,000, users may choose to proceed based on documents alone, by telephonic hearing, or through an in-person hearing. The arbitrator shall provide a reasoned written decision explaining the basis for the award.

                    5. **Costs of Arbitration**

                    Arbitration fees will be determined in accordance with the SIAC rules, and bythen agrees to abide by the arbitration verdict regarding the allocation of fees.

                    6. **Confidentiality**

                    The arbitration process, including any decisions or awards by the arbitrator, shall remain strictly confidential.

                    7. **Severability**

                    Should any term or provision of this Arbitration Agreement (aside from the “Prohibition of Class Actions and Non-Individualized Relief” clause) be deemed invalid or unenforceable, it will be replaced by a valid and enforceable term that closely reflects the original intention. If any part of the class action prohibition is found unenforceable, the entire Arbitration Agreement shall be null and void, but the remaining Terms of Use will continue to apply.

                    8. **Future Changes to Arbitration Agreement**

                    If bythen amends this Arbitration Agreement in the future (excluding updates to contact information), users may reject such changes by providing written notice within 30 days of the amendment. Continuing to use bythen after any changes to the Arbitration Agreement signifies acceptance of the new terms, except where a rejection has been formally submitted.

                    ### **10. Contact Us**

                    For any inquiries regarding bythen’s Terms of Use, users can contact bythen at **hello@bythen.ai** or through our social media handle **@bythenAI**.
                    """)
                    .markdownTextStyle {
                        FontFamily(.custom("NeueMontreal-Regular"))
                        FontSize(12)
                    }
                    .padding(16)
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .background(
                    Rectangle().fill(
                        .white,
                        strokeBorder: .byteBlack.opacity(0.3),
                        lineWidth: 1
                    )
                )
                .padding(.bottom, 14)
                .padding(.horizontal, 28)
                
                createCheckBoxButton(isAccepted: $isAccepted, text: "I accepted and agree to the Terms of Use.")
                
                createCheckBoxButton(isAccepted: $isAcceptedContact, text: "I agree to be contacted by bythen customer success team.")
                
                VStack(spacing: 12) {
                    CommonButton.basic(.rectangle, title: "ACCEPT", isDisabled: $shouldDisableAcceptButton) {
                        didAccept(isAccepted, isAcceptedContact)
                    }
                    
                    CommonButton.basic(.rectangleBordered, title: "DECLINE", colorScheme: .dark) {
                        didAccept(false, false)
                    }
                }
                .padding(.top, 40)
                .padding(.bottom, 28)
                .padding(.horizontal, 28)
            }
            .background(.white)
            .padding(.horizontal, 16)
        }
    }
    
    private func createCheckBoxButton(isAccepted: Binding<Bool>, text: String) -> some View {
        Button {
            isAccepted.wrappedValue.toggle()
            
            updateShouldEnableAcceptButton()
        } label: {
            HStack {
                Image(isAccepted.wrappedValue ? "check-box" : "check-box-blank")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.byteBlack.opacity(0.7))
                
                Text(text)
                    .font(.neueMontreal(size: 14))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.byteBlack)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 28)
            .padding(.top, 6)
        }
    }
    
    private func updateShouldEnableAcceptButton() {
        shouldDisableAcceptButton = !((isAccepted && isAcceptedContact) || isAccepted)
    }
}

#Preview {
    TermsOfServiceView()
}

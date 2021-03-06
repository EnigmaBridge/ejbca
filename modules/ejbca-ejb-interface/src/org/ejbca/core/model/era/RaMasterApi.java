/*************************************************************************
 *                                                                       *
 *  EJBCA Community: The OpenSource Certificate Authority                *
 *                                                                       *
 *  This software is free software; you can redistribute it and/or       *
 *  modify it under the terms of the GNU Lesser General Public           *
 *  License as published by the Free Software Foundation; either         *
 *  version 2.1 of the License, or any later version.                    *
 *                                                                       *
 *  See terms of license at gnu.org.                                     *
 *                                                                       *
 *************************************************************************/
package org.ejbca.core.model.era;

import java.security.KeyStoreException;
import java.util.List;
import java.util.Map;

import org.cesecore.authentication.AuthenticationFailedException;
import org.cesecore.authentication.tokens.AuthenticationToken;
import org.cesecore.authorization.AuthorizationDeniedException;
import org.cesecore.authorization.access.AccessSet;
import org.cesecore.certificates.ca.CAInfo;
import org.cesecore.certificates.certificate.CertificateDataWrapper;
import org.cesecore.certificates.certificateprofile.CertificateProfile;
import org.cesecore.certificates.endentity.EndEntityInformation;
import org.ejbca.core.EjbcaException;
import org.ejbca.core.model.approval.AdminAlreadyApprovedRequestException;
import org.ejbca.core.model.approval.ApprovalException;
import org.ejbca.core.model.approval.ApprovalRequestExecutionException;
import org.ejbca.core.model.approval.ApprovalRequestExpiredException;
import org.ejbca.core.model.approval.SelfApprovalException;
import org.ejbca.core.model.approval.WaitingForApprovalException;
import org.ejbca.core.model.approval.profile.ApprovalProfile;
import org.ejbca.core.model.ra.raadmin.EndEntityProfile;
import org.ejbca.core.model.ra.raadmin.UserDoesntFullfillEndEntityProfile;

/**
 * API of available methods on the CA that can be invoked by the RA.
 * 
 * Implementation restrictions:
 * - Keep in mind that there is latency, so batch things and don't for things twice unless it is expected to have change.
 * - Method names must be unique and signature is not allowed change after a release
 * - Any used object in this class must be Java Serializable
 * - Any used object in this class should be possible to use with an older or newer version of the peer
 * - Checked Exceptions are forwarded in full the implementation is responsible for not leaking sensitive information in
 *   nested causedBy exceptions.
 * 
 * @version $Id$
 */
public interface RaMasterApi {

    /** @return true if the implementation if the interface is available and usable. */
    boolean isBackendAvailable();
    
    /** Returns an AccessSet containing the access rules that are allowed for the given authentication token. */
    AccessSet getUserAccessSet(AuthenticationToken authenticationToken) throws AuthenticationFailedException;
    
    /** Gets multiple access sets at once. Returns them in the same order as in the parameter */
    List<AccessSet> getUserAccessSets(List<AuthenticationToken> authenticationTokens);

    /** @return a list with information about non-external CAs that the caller is authorized to see. */
    List<CAInfo> getAuthorizedCas(AuthenticationToken authenticationToken);

    /** @return the approval request with the given id, or null if it doesn't exist or if authorization was denied */
    RaApprovalRequestInfo getApprovalRequest(AuthenticationToken authenticationToken, int id);

    /**
     * Finds an approval by a hash of the request data.
     * 
     * @param approvalId Calculated hash of the request (this somewhat confusing name is re-used from the ApprovalRequest class)
     */
    RaApprovalRequestInfo getApprovalRequestByRequestHash(AuthenticationToken authenticationToken, int approvalId);
    
    /**
     * Modifies an approval request and sets the current admin as a blacklisted admin.
     * @return The new approval request (which may have a new id)
     */
    RaApprovalRequestInfo editApprovalRequest(AuthenticationToken authenticationToken, RaApprovalEditRequest edit) throws AuthorizationDeniedException;
    
    /** Approves, rejects or saves (not yet implemented) a step of an approval request. The action is determined by the "action" value in the given RaApprovalResponseRequest.
     * @return true if the approval request exists on this node, false if not.
     * @throws SelfApprovalException if trying to approve one's own action.
     * @throws AdminAlreadyApprovedRequestException if this approval request has been approved or rejected already.
     * @throws ApprovalRequestExecutionException if execution of the approval request (e.g. adding an end endity) failed.
     * @throws ApprovalRequestExpiredException if the approval request is older than the configured expiry time
     * @throws AuthenticationFailedException if the authentication token couldn't be validated
     * @throws ApprovalException is thrown for other errors, such as the approval being in the wrong state, etc.
     */
    boolean addRequestResponse(AuthenticationToken authenticationToken, RaApprovalResponseRequest requestResponse)
            throws AuthorizationDeniedException, ApprovalException, ApprovalRequestExpiredException, ApprovalRequestExecutionException,
            AdminAlreadyApprovedRequestException, SelfApprovalException, AuthenticationFailedException;
    
    /**
     * Searches for approval requests.
     * @param authenticationToken administrator (affects the search results)
     * @param raRequestsSearchRequest specifies which requests to include (e.g. requests that can be approved by the given administrator)
     * @return list of approval requests from the specified search criteria
     */
    RaRequestsSearchResponse searchForApprovalRequests(AuthenticationToken authenticationToken, RaRequestsSearchRequest raRequestsSearchRequest);
    
    /** @return CertificateDataWrapper if it exists and the caller is authorized to see the data or null otherwise*/
    CertificateDataWrapper searchForCertificate(AuthenticationToken authenticationToken, String fingerprint);
    
    /** @return list of certificates from the specified search criteria*/
    RaCertificateSearchResponse searchForCertificates(AuthenticationToken authenticationToken, RaCertificateSearchRequest raCertificateSearchRequest);

    /** @return list of end entities from the specified search criteria*/
    RaEndEntitySearchResponse searchForEndEntities(AuthenticationToken authenticationToken, RaEndEntitySearchRequest raEndEntitySearchRequest);

    /** @return map of authorized certificate profile Ids and each mapped name */
    Map<Integer, String> getAuthorizedCertificateProfileIdsToNameMap(AuthenticationToken authenticationToken);

    /** @return map of authorized entity profile Ids and each mapped name */
    Map<Integer, String> getAuthorizedEndEntityProfileIdsToNameMap(AuthenticationToken authenticationToken);

    /** @return map of authorized end entity profiles for the provided authentication token */
    IdNameHashMap<EndEntityProfile> getAuthorizedEndEntityProfiles(AuthenticationToken authenticationToken);

    /** @return map of authorized and enabled CAInfos for the provided authentication token*/
    IdNameHashMap<CAInfo> getAuthorizedCAInfos(AuthenticationToken authenticationToken);

    /** @return map of authorized certificate profiles for the provided authentication token*/
    IdNameHashMap<CertificateProfile> getAuthorizedCertificateProfiles(AuthenticationToken authenticationToken);
    
    /**
     * Adds (end entity) user.
     * @param admin authentication token
     * @param endEntity end entity data as EndEntityInformation object
     * @param clearpwd 
     * @throws AuthorizationDeniedException
     * @throws EjbcaException if an EJBCA exception with an error code has occurred during the process
     * @throws WaitingForApprovalException if approval is required to finalize the adding of the end entity
     * @throws UserDoesntFullfillEndEntityProfile endEntity doesn't fullfill profile
     * @return true if used has been added, false otherwise
     */
    boolean addUser(AuthenticationToken authenticationToken, EndEntityInformation endEntity, boolean clearpwd) throws AuthorizationDeniedException,
    EjbcaException, WaitingForApprovalException, UserDoesntFullfillEndEntityProfile;

    /**
     * Deletes (end entity) user. Does not propagate the exceptions but logs them.
     * @param authenticationToken
     * @param username the username of the end entity user about to delete
     * @throws AuthorizationDeniedException
     */
    void deleteUser(final AuthenticationToken authenticationToken, final String username) throws AuthorizationDeniedException;
    
    /**
     * Generates keystore for the specified end entity. Used for server side generated key pairs. It can be of PKCS12 or JKS type.
     * Keystore can be loaded with:
     *  
     * KeyStore ks = KeyStore.getInstance(endEntityInformation.getTokenType() == EndEntityConstants.TOKEN_SOFT_P12 ? "PKCS12" : "JKS");
     * ks.load(new ByteArrayInputStream(keystoreAsByteArray), endEntityInformation.getPassword().toCharArray());
     * 
     * Note that endEntityInformation are still needed to load a keystore.
     * @param authenticationToken authentication token
     * @param endEntityInformation holds end entity information (including user's password)
     * @return generated keystore
     * @throws AuthorizationDeniedException
     * @throws KeyStoreException if something went wrong with keystore creation
     */
    byte[] generateKeystore(AuthenticationToken authenticationToken, EndEntityInformation endEntityInformation)
            throws AuthorizationDeniedException, EjbcaException, Exception;

    /**
     * Generates certificate from CSR for the specified end entity. Used for client side generated key pairs.
     * @param authenticationToken authentication token
     * @param endEntity end entity information. CertificateRequest (CSR) must be set under extendedInformation of the endEntityInformation. 
     * @param certificateRequest CSR as PKCS10CertificateRequst object
     * @return certificate binary data
     * @throws AuthorizationDeniedException
     * @throws EjbcaException if an EJBCA exception with an error code has occurred during the process
     */
    byte[] createCertificate(AuthenticationToken authenticationToken, EndEntityInformation endEntity)
            throws AuthorizationDeniedException, EjbcaException;

    /**
     * Finds end entity by its username.
     * @param authenticationToken authentication token
     * @param username username of the end entity
     * @return end entity as EndEntityInformation
     * @throws AuthorizationDeniedException
     */
    EndEntityInformation searchUser(AuthenticationToken authenticationToken, String username);

    /**
     * Request status change of a certificate (revoke or reactivate).
     * Requires authorization to CA, EEP for the certificate and '/ra_functionality/revoke_end_entity'.
     * 
     * @param authenticationToken of the requesting administrator or client
     * @param fingerprint of the certificate
     * @param newStatus CertificateConstants.CERT_REVOKED (40) or CertificateConstants.CERT_ACTIVE (20)
     * @param newRevocationReason One of RevokedCertInfo.REVOCATION_REASON_...
     * @return true if the operation was successful, false if the certificate could not be revoked for example since it did not exist
     * @throws ApprovalException if there was a problem creating the approval request
     * @throws WaitingForApprovalException if the request has been sent for approval
     */
    boolean changeCertificateStatus(AuthenticationToken authenticationToken, String fingerprint, int newStatus, int newRevocationReason)
            throws ApprovalException, WaitingForApprovalException;
    
    
    /**
     * Gets approval profile for specified action.
     * 
     * @param action. Check CAInfo.AVAILABLE_APPROVALSETTINGS for valid values.
     * @param cainfo CA non sensitive data
     * @return certProfile certificate profile
     */
    public ApprovalProfile getApprovalProfileForAction(final int action, final CAInfo cainfo, final CertificateProfile certProfile);//TODO Authentication

}
